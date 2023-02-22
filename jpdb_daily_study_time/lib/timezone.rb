require "tzinfo"

module Timezone
  def self.for_seconds_timestamp(timestamp)
    timezone_name =
      # March 2 to March 9, 2023 trip to the east coast
      if timestamp > 1677754800 && timestamp < 1678359600
        "America/New_York"
      else
        "America/Chicago"
      end

    TZInfo::Timezone.get(timezone_name)
  end
end
