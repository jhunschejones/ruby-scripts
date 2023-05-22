require "tzinfo"

module Timezone
  def self.for_seconds_timestamp(timestamp)
    timezone_name =
      # March 2 to March 9, 2023 trip to the east coast
      if timestamp > 1677754800 && timestamp < 1678359600
        "America/New_York"
      # May 10 to May 16, 2023 trip to the east coast
      elsif timestamp > 16837128000 && timestamp < 16842816000
        "America/New_York"
      else
        "America/Chicago"
      end

    TZInfo::Timezone.get(timezone_name)
  end
end
