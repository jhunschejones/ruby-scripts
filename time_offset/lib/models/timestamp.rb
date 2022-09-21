require "time"

class Timestamp
  RANGE_SEPARATOR = "-".freeze

  def initialize(user_string)
    @sanitized_user_string = user_string
      .gsub(".", "")
      .strip
    @offset_seconds = 0

    set_start_time
    set_end_time
    self
  end

  def offset(seconds:)
    @offset_seconds = seconds
    self
  end

  def to_s
    timestamp_string = (@start_time + @offset_seconds).strftime("%M:%S")
    if @end_time
      timestamp_string << "-#{(@end_time + @offset_seconds).strftime("%M:%S")}"
    end
    timestamp_string
  end

  private

  def set_start_time
    start_time_string = @sanitized_user_string
      .split(RANGE_SEPARATOR)
      .first
      .strip
    @start_time = Time.strptime(start_time_string, "%M:%S")
  end

  def set_end_time
    if @sanitized_user_string.split(RANGE_SEPARATOR).one?
      @end_time = nil
      return
    end

    end_time_string = @sanitized_user_string
      .split(RANGE_SEPARATOR)
      .last
      .strip
    @end_time = Time.strptime(end_time_string, "%M:%S")
  end
end
