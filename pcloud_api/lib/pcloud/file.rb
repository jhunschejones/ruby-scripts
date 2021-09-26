module Pcloud
  class File
    attr_reader :id, :name, :content_type, :parent_folder_id, :is_deleted

    def initialize(id:, name:, content_type:, parent_folder_id:, is_deleted:)
      @id = id
      @name = name
      @content_type = content_type
      @parent_folder_id = parent_folder_id
      @is_deleted = is_deleted
    end

    def download_url
      @download_url ||= begin
        file_url_parts = Api.execute(
          "getfilelink",
          query: { fileid: id, forcedownload: 1, skipfilename: 1 }
        )
        "https://#{file_url_parts["hosts"].first}#{file_url_parts["path"]}"
      end
      # This allows us to cache the expensive part of this method, requesting
      # a download URL from pcloud, while maintaining consistency if the file
      # name changes later.
      "#{@download_url}/#{@name}"
    end

    def download_to(local_file_path:)
      ::File.open(local_file_path, "w") do |file|
        file.binmode
        print "Saving your file.."
        HTTParty.get(download_url, stream_body: true) do |fragment|
          file.write(fragment)
          print "."
        end
        puts "."
      end
      true
    end

    def update(name:)
      Pcloud::File.parse_one(
        Api.execute("renamefile", query: { fileid: id, toname: name })
      )
    end

    def move_to(folder_id:)
      Pcloud::File.parse_one(
        Api.execute("renamefile", query: { fileid: id, tofolderid: folder_id, toname: name })
      )
    end

    def delete
      Pcloud::File.parse_one(
        Api.execute("deletefile", query: { fileid: id })
      )
    end

    def parent_folder
      # This is safe to cache with the current implemenatation since the `move_to`
      # method returns an enierly new instance with updated attributes.
      @parent_folder ||= Pcloud::Folder.find(parent_folder_id)
    end

    class << self
      def find_by(path:)
        parse_one(Api.execute("stat", query: { path: path }))
      end

      def find(id)
        parse_one(Api.execute("stat", query: { fileid: id }))
      end

      def upload(filename:, file:, path: nil, folder_id: nil)
        # If neither `path` nor `folder_id` is provided, the file will be
        # uploaded into the users root directory by default.
        response = Api.execute(
          "uploadfile",
          body: {
            renameifexists: 1,
            path: path,
            folderid: folder_id,
            filename: filename,
            file: file
          }.compact,
        )
        parse_many(response).first
      end

      def parse_one(response)
        new(
          id: response.dig("metadata", "fileid"),
          name: response.dig("metadata", "name"),
          content_type: response.dig("metadata", "contenttype"),
          parent_folder_id: response.dig("metadata", "parentfolderid"),
          is_deleted: response.dig("metadata", "isdeleted") || false
        )
      end

      def parse_many(response)
        response["metadata"].map do |metadata|
          new(
            id: metadata["fileid"],
            name: metadata["name"],
            content_type: metadata["contenttype"],
            parent_folder_id: metadata["parentfolderid"],
            is_deleted: metadata["isdeleted"] || false
          )
        end
      end
    end
  end
end
