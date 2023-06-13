require "tzinfo"

module Timezone
  def self.for_seconds_timestamp(timestamp)
    timezone_name =
      # March 2 to March 9, 2023 trip to the east coast
      if timestamp > 1677754800 && timestamp < 1678359600
        "America/New_York"
      # May 10 to May 16, 2023 trip to the east coast
      elsif timestamp > 1683712800 && timestamp < 1684281600
        "America/New_York"
      # June 7 to June 16, 2023 trip to west coast
      elsif timestamp > 1686135600 && timestamp < 1686409200
        "America/Los_Angeles"
      else
        "America/Chicago"
      end

    TZInfo::Timezone.get(timezone_name)
  end
end
