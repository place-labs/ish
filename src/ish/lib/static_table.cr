require "./table"

struct StaticTable(T, M, N) < Table(T, M, N)
  @buffer : StaticArray(StaticArray(T, N), M)

  def initialize(&block : Int32, Int32 -> T)
    @buffer = StaticArray(StaticArray(T, N), M).new do |a|
      StaticArray(T, N).new do |b|
        yield a, b
      end
    end
  end
end
