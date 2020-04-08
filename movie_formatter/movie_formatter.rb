require_relative './lib/module_loader'

Dir.chdir("./to_format")
FileManager.delete_extra_files
FileManager.rename_files
FileManager.organize_files
