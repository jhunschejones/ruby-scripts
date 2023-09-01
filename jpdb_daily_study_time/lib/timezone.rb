require "tzinfo"
require "time"

module Timezone
  # `timestamp` is a 10-digit integer for seconds since unix epoch
  def self.for_seconds_timestamp(timestamp)
    time_from_timestamp = Time.at(timestamp)
    timezone_name =
      if time_from_timestamp > Time.parse("2023-03-02 05:00:00 -0600") &&
         time_from_timestamp < Time.parse("2023-03-09 05:00:00 -0600")
        "America/New_York"
      elsif time_from_timestamp > Time.parse("2023-05-10 05:00:00 -0500") &&
            time_from_timestamp < Time.parse("2023-05-16 19:00:00 -0500")
        "America/New_York"
      elsif time_from_timestamp > Time.parse("2023-06-07 06:00:00 -0500") &&
            time_from_timestamp < Time.parse("2023-06-10 10:00:00 -0500")
        "America/Los_Angeles"
      elsif time_from_timestamp > Time.parse("2023-08-23 05:00:00 -0500") &&
            time_from_timestamp < Time.parse("2023-08-30 06:00:00 -0500")
        "America/Los_Angeles"
      else
        "America/Chicago"
      end

    TZInfo::Timezone.get(timezone_name)
  end
end
