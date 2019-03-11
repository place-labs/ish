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
    instance = CountMinSketch.new epsilon: 1e-5, delta: 1e-2

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

    it "provides an estimate within stated bounds" do
      # Insert some other noise
      100000.times { instance << rand }

      estimate = instance.count "Foo"
      actual   = 1000
      n        = 100001

      actual.should be <= estimate
      estimate.should be <= (actual + instance.epsilon * n)
    end
  end
end
