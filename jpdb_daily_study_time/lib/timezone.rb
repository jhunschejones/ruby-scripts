require "tzinfo"

module Timezone
  def self.for_seconds_timestamp(timestamp)
    timezone_name =
      # Start of March 2 to start of March 9, 2023
      if timestamp > 1677736800 && timestamp < 1678341600
        "America/New_York"
      else
        "America/Chicago"
      end

    TZInfo::Timezone.get(timezone_name)
  end
end
