require "tzinfo"
require "time"
require "yaml"

module Timezone
  TimezoneChange = Struct.new(:start_date, :end_date, :timezone, keyword_init: true)

  TIMEZONE_CHANGES_FILEPATH = "config/timzeone_changes.yml"
  TIMEZONE_CHANGES =
    if File.exist?(TIMEZONE_CHANGES_FILEPATH)
      YAML.load(File.read(TIMEZONE_CHANGES_FILEPATH), permitted_classes: [Time])
        .fetch("timezone_changes", [])
        .map { |tzc| TimezoneChange.new(start_date: tzc["start_date"], end_date: tzc["end_date"], timezone: tzc["timezone"])}
    else
      []
    end
  DEFAULT_TIMEZONE = "America/Chicago"

  # `timestamp` is a 10-digit integer for seconds since unix epoch
  def self.for_seconds_timestamp(timestamp)
    time_from_timestamp = Time.at(timestamp)
    sorted_timezone_changes = TIMEZONE_CHANGES.sort_by(&:start_date)
    uncompleted_timezone_changes, completed_timezone_changes = sorted_timezone_changes.partition { |tzc| tzc.end_date.nil? }

    timezone_name = nil
    completed_timezone_changes.each do |timezone_change|
      if time_from_timestamp > timezone_change.start_date && time_from_timestamp < timezone_change.end_date
        # timestamp falls in the middle of a completed timezone_change
        timezone_name = timezone_change.timezone
        break
      end
    end

    # if timezone_name is still nil, that means it does not fall in the middle of a completed timezone change
    # so we want to try and see if there is an uncompleted timezone change that might apply
    if timezone_name.nil?
      uncompleted_timezone_changes.each do |timezone_change|
        if time_from_timestamp > timezone_change.start_date
          # timestamp falls inside an uncompleted / currently active timezone_change
          timezone_name = timezone_change.timezone
          break
        end
      end
    end

    TZInfo::Timezone.get(timezone_name || DEFAULT_TIMEZONE) # use the default if we still haven't found a matching timezone in the config
  end
end
