require_relative "./lib/module_loader"

ANKI_BACKUPS_FOLDER_ID = 7263422653.freeze
ANKI_BACKUP_ARCHIVES_FOLDER_ID = 7453102322.freeze

puts "Drag and drop the Anki deck file to backup:".cyan
print "> "
deck_file_path = $stdin.gets.chomp.strip.gsub("\\", "")
exit 0 if ["quit", "exit", "q"].include?(deck_file_path.downcase)

uploaded_file = Pcloud::File.upload(
  folder_id: ANKI_BACKUPS_FOLDER_ID,
  filename: deck_file_path.split("/").last,
  file: File.open(deck_file_path)
)

puts "'#{uploaded_file.name}' was sucessfully uploaded to '#{uploaded_file.parent_folder.name}'".green

# Move previous versions of a specific deck into the `_Archives` folder based
# on first word of the file name. This means when `Radicals 09.25.21.apkg` is
# uploaded, `Radicals 04.15.21.apkg` will be automatically moved to the
# `_Archives` folder.
class Pcloud::File
  def is_a_newer_version_of?(previous_file)
    previous_file.is_a?(Pcloud::File) &&
      previous_file.id != self.id &&
      previous_file.name.split.first == self.name.split.first
  end
end

uploaded_file.parent_folder.contents.each do |file|
  if uploaded_file.is_a_newer_version_of?(file)
    file.move_to(folder_id: ANKI_BACKUP_ARCHIVES_FOLDER_ID)
  end
end
