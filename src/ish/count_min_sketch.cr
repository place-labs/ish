require "./tools/*"
require "math"

# A Count-Min sketch is a probabilistic data structure used for summarizing
# streams of data in sub-linear space.
#
# It works as follows. Let `(epsilson, delta)` be two parameters that describe
# the confidence in our error estimates, and let `d = ceil(ln 1/delta)` and
# `w = ceil(e / epsilon)`.
#
# Then:
#
# - Take `d` pairwise independent hash functions `h_i`, each of which maps
#   onto the domain `[0, w - 1]`.
# - Create a 2-dimensional table of counts, with `d` rows and `w` columns,
#   initialized with all zeroes.
# - When a new element x arrives in the stream, update the table of counts
#   by setting `counts[i, h_i[x]] += 1`, for each `1 <= i <= d`.
# - (Note the rough similarity to a Bloom filter.)
#
# As an example application, suppose you want to estimate the number of times
# an element `x` has appeared in a data stream so far. The Count-Min sketch
# estimate of this frequency is
#
#   min_i { counts[i, h_i[x]] }
#
# With probability at least `1 - delta`, this estimate is within `epsilon * N`
# of the true frequency, i.e.
#
#   true frequency <= estimate <= true frequency + epsilon * N`
#
# where N is the total size of the stream so far.
class Ish::CountMinSketch


  # Create a count-min sketch of the specified size.
  def initialize(@width : UInt32, @depth : UInt32)
    #@table = Array.new(@width) { Array.new(@depth) }
  end

  # Create a count-min sketch with the specified accuracy characteristics.
  def self.new(epsilon : Float32 = 0.1, delta : Float32 = 1e-6)
    Assert.bounded epsilon, 0, 1
    Assert.bounded delta, 0, 1

    width = (Math::E / epsilon).ceil.to_u
    depth = Math.log(1 / delta).ceil.to_u

    super width, depth
  end

  def self.new(width : Int32, depth : Int32)
    Assert.greater_than width, 0
    Assert.greater_than depth, 0

    new width.to_u, depth.to_u
  end
end
