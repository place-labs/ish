require "math"

# A Count-Min sketch is a probabilistic data structure used for summarizing
# streams of data in sub-linear space.
#
# Space requirements are bounded and are not dependant on the number of items
# to be tracked. Instead, performance is modelled by the following two
# parameters:
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

  # Create a count-min sketch with the specified accuracy characteristics.
  def initialize(epsilon : Float32 = 0.1, delta : Float32 = 1e-6)
    assert_unit_interval epsilon
    assert_unit_interval delta

    width = (Math::E / epsilon).ceil.to_u
    depth = Math.log(1 / delta).ceil.to_u

    @sketch = Array.new(depth) { Array.new(width, 0_u32) }
  end

  # Increase the count of an item within the sketch.
  def increment(item, amount = 1)
    buckets(item).each { |row, i| row.update(i, &.+(amount)) }
    self
  end

  # Retrieve a frequency estimate for an item.
  def count(item)
    buckets(item).map { |row, i| row.fetch i }
                 .min
  end

  # Provide an Iterator with the set of hashes for an item.
  private def hash(item)
    @hash_functions.each.map &.call(item)
  end

  # Given an item, provide an iterator containing each layer of the sketch and
  # it's associated bucket index.
  private def buckets(item)
    @sketch.each.zip hash(item)
  end
end
