require "./table"

struct HeapTable(T, M, N) < Table(T, M, N)
  @buffer : Array(Array(T))

  def initialize
    @buffer = Array.new(M) do |a|
      Array.new(N) do |b|
        yield a, b
      end
    end
  end
end
