# frozen_string_literal: true

# class and new instance methods for different operations
class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def intersection(other)
    return nil if (max < other.begin) || (other.max < self.begin)

    [self.begin, other.begin].max..[max, other.max].min
  end
  alias & intersection

  def difference
    max - min
  end

  def -(other)
    return self if last < other.first

    out = []
    unless other.first <= first && other.last >= last
      out << Range.new(first, other.first) if other.first > first
      out << Range.new(other.last, last) if other.last < last
    end
    out
  end
end
