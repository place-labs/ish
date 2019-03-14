abstract struct Table(T, M, N)
  def self.new(value : T)
    new { value }
  end

  abstract def initialize(&block : UInt32, UInt32 -> T)

  def [](a, b)
    @buffer[a][b]
  end

  def []=(a, b, value)
    @buffer[a][b] = value
  end

  def update(a, b, &block : UInt32, UInt32 -> T)
    self[a, b] = yield self[a, b]
  end

  def each
    @buffer.each.map(&.each).reduce(&.chain)
  end

  def map(&block : T -> U) forall U
    self.class(U, M, N).new { |a, b| yield self[a, b] }
  end

  def map_with_indices(&block : UInt32, UInt32, T -> U) forall U
    self.class(U, M, N).new { |a, b| yield self[a, b], a, b }
  end

  def map!(&block)
    @buffer.each &.map!(&block)
  end

  def map_with_indicies!(&block : UInt32, UInt32, T -> U) forall U
    @buffer.each_with_index do |a, i|
      a.map_with_index! { |b, j| block.call(b, i, j) }
    end
  end
end
