module Ish
  class Matrix(T)
    @m : UInt32
    @n : UInt32
    @buffer : Pointer(T)

    # Creates a *m* x *n* matrix with each element initialized as *value*.
    def self.new(m : Int, n : Int, value : T)
      Matrix(T).new(m, n) { value }
    end

    # Creates an *m* x *n* matrix, yielding indicies for each element to
    # provide an initial value.
    def initialize(m : Int, n : Int, &block : UInt32, UInt32 -> T)
      if m < 1 || n < 1
        raise ArgumentError.new("Matrix dimensions must be natural numbers")
      end

      @m = m.to_u32
      @n = n.to_u32

      size = (m * n).to_i
      @buffer = Pointer(T).malloc(size) do |idx|
        i, j = address idx
        yield i, j
      end
    end

    # Retrieves the value of the element at *i*,*j*.
    #
    # Indicies are zero-based. Negative values may be passed for *i* and *j* to
    # enable reverse indexing such that `self[-1, -1] == self[m - 1, n - 1]`
    # (same behaviour as arrays).
    def [](i : Int, j : Int) : T
      idx = index i, j
      @buffer[idx]
    end

    # Sets the value of the element at *i*,*j*.
    def []=(i : Int, j : Int, value : T)
      idx = index i, j
      @buffer[idx] = value
    end

    # Returns the dimensions of `self` as a tuple of `{m, n}`.
    def size
      {@m, @n}
    end

    # Yields the current element at *i*,*j* and updates the value with the
    # block's return value.
    def update(i, j, &block : T -> T)
      idx = index i, j
      @buffer[idx] = yield @buffer[idx]
    end

    # Map *i*,*j* coords to an index within the buffer.
    private def index(i : Int, j : Int)
      i += @m if i < 0
      j += @n if j < 0

      raise IndexError.new if i < 0 || j < 0
      raise IndexError.new unless i < @m && j < @n

      i * @n + j
    end

    # Maps buffer indicies to *i*,*j* coords.
    private def address(idx : Int)
      raise IndexError.new unless idx < @m * @n

      i = (idx / @n).to_u32
      j = (idx % @n).to_u32

      {i, j}
    end
  end
end
