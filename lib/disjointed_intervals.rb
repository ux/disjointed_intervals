class DisjointedIntervals
  attr_reader :intervals

  def initialize(intervals = [])
    @intervals = intervals
  end

  def add(from, to)
    ensure_interval_correctness!(from, to)

    cover_intervals(from, to) do |left_index, right_index|
      if right_index
        merge_intervals(left_index, right_index, from, to)
      else
        add_interval(left_index, from, to)
      end
    end

    intervals
  end

  def remove(from, to)
    ensure_interval_correctness!(from, to)

    cover_intervals(from, to) do |left_index, right_index|
      cut_intervals(left_index, right_index, from, to) if right_index
    end

    intervals
  end

  private

  def ensure_interval_correctness!(from, to)
    raise ArgumentError, "Invalid arguments: from=#{from}, to=#{to}" unless from && to && from < to
  end

  # yields interval indexes, where intervals range is intersected by `from`-`to` range
  def cover_intervals(from, to)
    left_index = get_closest_right_interval_index(from)

    # pass interval in the end if there are no intervals after `from`
    return yield(-1, nil) unless left_index

    right_index = get_closest_right_interval_index(to)

    # pick the last one interval if there are no intervals after `to`
    right_index ||= intervals.length - 1

    # get previous interval if right interval starts after `to`
    right_index -= 1 if intervals[right_index][0] > to

    # pass interval before left interval if initially found right interval starts after `to` and
    # left interval is equal to right interval
    return yield(left_index, nil) if right_index < left_index

    yield(left_index, right_index)
  end

  # returns either index of interval which is next to number specified or interval which includes this number
  def get_closest_right_interval_index(number)
    intervals.bsearch_index { |interval| interval[1] >= number }
  end

  # add interval at specific position
  def add_interval(index, from, to)
    intervals.insert(index, [from, to])
  end

  # replace intervals with a single one, which covers all of them
  def merge_intervals(left_index, right_index, from, to)
    left_interval, right_interval = intervals.values_at(left_index, right_index)

    new_from = [left_interval[0], from].min
    new_to = [right_interval[1], to].max

    intervals[left_index..right_index] = [[new_from, new_to]]
  end

  def cut_intervals(left_index, right_index, from, to)
    left_interval, right_interval = intervals.values_at(left_index, right_index)

    intervals[left_index..right_index] = [].tap do |new_intervals|
      new_intervals << [left_interval[0], from] if from > left_interval[0]
      new_intervals << [to, right_interval[1]] if to < right_interval[1]
    end
  end
end
