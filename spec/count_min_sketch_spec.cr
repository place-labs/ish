require "spec"
require "../src/ish/count_min_sketch"

CountMinSketch = Ish::CountMinSketch

describe CountMinSketch do
  it "raises exception for invalid parameters" do
    expect_raises(ArgumentError) do
      CountMinSketch.new 0.0, 0.0
    end

    expect_raises(ArgumentError) do
      CountMinSketch.new 1, 0.0001
    end
  end
end
