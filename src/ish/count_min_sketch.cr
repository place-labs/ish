require "math"

# A Count-Min sketch is a probabilistic data structure used for summarizing
# streams of data in sub-linear space.
#
# Performance is modelled by the following two parameters:
#
#   epsilon: the error factor
#     delta: probability of error
#
# With N insertions, the sketch will provide estimate counts within
# `epsilon * N` of the true frequency at a probability of at least `1 - delta`.
# It follows that the sketch never underestimates the true value, though it may
# overestimate.
#
#   `true frequency <= estimate <= true frequency + epsilon * N``
#
# Error within estimates is proportional to the total aggregate number of
# occurences seen, and to the epsilon. This also means significantly larger
# truth values can dwarf smaller the error term producing more accurate
# estimates for items with the largest counts.
#
# Further information and proofs can be found at
# http://dimacs.rutgers.edu/~graham/pubs/papers/cmencyc.pdf
#
# OPTIMIZE: support parallel hashing / increment / count operations when
# supported by Crystal
class Ish::CountMinSketch
  @sketch : Array(Array(UInt32))

  private macro assert_unit_interval(value)
    if {{value}} <= 0 || {{value}} >= 1
      raise ArgumentError.new "{{value}} must be between 0 and 1, exclusive"
    end
  end

  # Create a count-min sketch with the specified characteristics.
  #
  # When choosing a configuration, you are often trying to minimize the error
  # term of the estimate. Acceptable errors in estimation fall within a range
  # which is a factor of *epsilon*. Smaller values of *epsilon* should produce
  # sketch configurations that provide estimates closer to the true values.
  # However, this will increase the space required by the sketch.
  #
  # Error in estimation is also proportional to the total number of distinct
  # items counted. A factor in the error term is a summation of total number
  # of occurences of each distinct item. Another way to reduce the error term
  # is by counting fewer things.
  #
  # Alternatively, you may try to reduce the frequency error and increase the
  # chance of success. This is modeled as `1.0 - delta`. Increasing this number
  # can produce sketch configurations with reduced error rates, but that will
  # require more memory.
  #
  # A good rule of thumb for finding a starting configuration is to try an
  # epsilon with as many significant digits as you have digits in your expected
  # volume (e.g. given an expected volume of 5000 a good starting point for
  # epsilon might be `0.0001`).
  #
  # An excellent resource that provides visualisation of different
  # configurations can be found at http://crahen.github.io/algorithm/stream/count-min-sketch-point-query.html
  def initialize(epsilon : Float32, delta : Float32)
    assert_unit_interval epsilon
    assert_unit_interval delta

    width = (Math::E / epsilon).ceil.to_u
    depth = Math.log(1 / delta).ceil.to_u

    @sketch = Array.new(depth) { Array.new(width, 0_u32) }
  end

  # Increase the count of *item* within the sketch by *amount* (default 1).
  def increment(item, amount = 1)
    buckets(item).each { |row, i| row.update(i, &.+(amount)) }
    self
  end

  # Insert *item*, incrementing its count by 1.
  def <<(item)
    increment item, 1
  end

  # Retrieve a frequency estimate for *item*.
  def count(item)
    buckets(item).map { |row, i| row.fetch i }
                 .min
  end

  # Provide an Iterator with the set of hashes for *item*.
  private def hash(item)
    @hash_functions.each.map &.call(item)
  end

  # Given an item, provide an Iterator containing a Tuple of each layer of the
  # sketch and the associated bucket index.
  private def buckets(item)
    @sketch.each.zip hash(item)
  end
end
