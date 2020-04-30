class Episode
  DARLING_IN_THE_FRANXX_MATCHER = /^.*\](.*)\s-\s(\d{2}).*(\d{4}p).*$/

  def self.from_file(file)
    show_name, episode_number, episode_resolution = File.basename(file, ".*").match(DARLING_IN_THE_FRANXX_MATCHER).captures
    new(
      file: file,
      number: episode_number,
      show_name: show_name.strip,
      name: nil,
      resolution: episode_resolution
    )
  end

  attr_accessor :file, :number, :show_name, :name, :resolution

  def initialize(file:, number:, show_name:, name: nil, resolution: nil)
    @file = file
    @number = number
    @show_name = show_name
    @name = name
    @resolution = resolution
  end

  def formatted_file_name
    "#{show_name} - S01E#{number} - #{name} [#{resolution}]#{File.extname(file)}"
  end
end
