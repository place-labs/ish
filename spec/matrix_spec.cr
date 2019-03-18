require "spec"
require "../src/ish/lib/matrix"

alias Matrix = Ish::Matrix

describe Matrix do
  describe "#initialize" do
    it "supports initialization with a single value" do
      Matrix(Int32).new(10, 10, 42)
    end

    it "supports initialization via a block" do
      Matrix(UInt32).new(10, 10) do |i, j|
        i * j
      end
    end
  end

  describe "#[]" do
    a = Matrix(UInt32).new(10, 10) { |i, j| i * j }

    it "supports lookups based on element indices" do
      a[0, 0].should eq(0)
      a[9, 9].should eq(81)
    end

    it "support negative index lookups" do
      a[-1, -1].should eq(81)
    end

    it "raises IndexError when out of bounds" do
      expect_raises(IndexError) { a[10, 0] }
      expect_raises(IndexError) { a[-11, 0] }
    end
  end

  describe "#[]=" do
    a = Matrix(Int32).new(10, 10, 0)

    it "supports assigning new values to elements" do
      a[0, 0] = 42
      a[0, 0].should eq(42)
      a[0, 1].should eq(0)
    end
  end

  describe "#update" do
    a = Matrix(Int32).new(10, 10, 42)

    it "yields the current value" do
      a.update(0, 0) do |x|
        x.should eq(42)
        x
      end
    end

    it "assigns the returned value to the element" do
      a.update(0, 0) { 1234 }
      a[0, 0].should eq(1234)
    end
  end

  describe "#size" do
    a = Matrix(Int32).new(10, 5, 42)

    it "returns the size as a tuple of {m, n}" do
      a.size.should eq({10, 5})
    end
  end
end
