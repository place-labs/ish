require "spec"
require "../src/ish/count_min_sketch"

CountMinSketch = Ish::CountMinSketch

describe CountMinSketch do
  it "raises exception for invalid parameters" do
    expect_raises(ArgumentError) do
      CountMinSketch.new 0.0, 0.0
    end

    expect_raises(ArgumentError) do
      CountMinSketch.new 1.0, 0.0001
    end
  end

  describe "#increment" do
    instance = CountMinSketch.new epsilon: 1e-3, delta: 1e-2

    it "support arbitrary objects" do
      instance.increment "Foo"
      instance.increment 42
      instance.increment ->{ "ping!" }
    end

    it "supports arbitrary incrementation steps" do
      instance.increment "Foo", 3
    end

    it "supports shorthand syntax" do
      instance << "Foo"
    end
  end

  describe "#count" do
    instance = CountMinSketch.new epsilon: 1e-3, delta: 1e-2

    it "initializes with zero counts" do
      instance.count("Foo").should eq(0)
      instance.count(42).should eq(0)
    end

    it "provides an accurate count for first insertion" do
      instance << "Foo"
      instance.count("Foo").should eq(1)
    end

    it "provides an accurate count for multiple insertion" do
      999.times { instance << "Foo" }
      instance.count("Foo").should eq(1000)
    end

    it "provides an good estimate for skewed datasets" do
      counter = Hash(String | Float64, UInt32).new { |h, k| h[k] = 0 }
      r = Random.new

      # Insert some noise with a even frequency distribution
      50000.times { instance << r.rand }

      # Insert and measure skewed values
      100.times do
        item = r.rand
        count = r.rand(50..300).to_u
        instance.increment item, count
        counter[item] += count
      end

      insertions = 51100 # includes previous tests
      error = 2 * insertions / instance.width

      counter.each do |item, actual|
        estimate = instance.count item
        estimate.should be >= actual
        estimate.should be_close(actual, error)
      end
    end
  end
end
