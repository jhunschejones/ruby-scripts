module Pcloud
  class Folder
    attr_reader :id, :path, :name, :parent_folder_id

    def initialize(id:, path:, name:, parent_folder_id:, contents:)
      @id = id
      @path = path
      @name = name
      @parent_folder_id = parent_folder_id
      @contents = contents
    end

    def update(name:)
      Pcloud::Folder.parse_one(
        Api.execute("renamefolder", query: { folderid: id, toname: name })
      )
    end

    # This method is the safest way to delte folders and will fail if the folder
    # has contents.
    def delete
      Pcloud::Folder.parse_one(
        Api.execute("deletefolder", query: { folderid: id })
      )
    end

    # This method will delete a folder and recursively delete all its contents
    def delete!
      Api.execute("deletefolderrecursive", query: { folderid: id })
      true # we don't get anything helpful back from pCloud on this request
    end

    def parent_folder
      # NOTE: This is safe to cache for now because support for moving folders
      #       has not been added yet.
      @parent_folder ||= Pcloud::Folder.find(parent_folder_id)
    end

    def contents
      # Some of the APIs don't return any contents for folders. This method
      # provides a way to try to find contents if we have one of these Folder
      # objects with a `nil` contents attribute.
      @contents ||= Pcloud::Folder.find(id).contents
    end

    class << self
      def create_if_not_exists(path:)
        parse_one(Api.execute("createfolderifnotexists", query: { path: path }))
      end

      def find_by(path:)
        parse_one(Api.execute("listfolder", query: { path: path }))
      end

      def find(id)
        parse_one(Api.execute("listfolder", query: { folderid: id }))
      end

      def parse_one(response)
        new(
          id: response.dig("metadata", "folderid"),
          path: response.dig("metadata", "path"),
          name: response.dig("metadata", "name"),
          parent_folder_id: response.dig("metadata", "parentfolderid"),
          contents: (response.dig("metadata", "contents") || []).map do |content_item|
            if content_item["isfolder"]
              new(
                id: content_item["folderid"],
                path: nil,
                name: content_item["name"],
                parent_folder_id: content_item["parentfolderid"],
                contents: nil
              )
            else
              Pcloud::File.new(
                id: content_item["fileid"],
                name: content_item["name"],
                content_type: content_item["contenttype"],
                parent_folder_id: content_item["parentfolderid"],
                is_deleted: content_item["isdeleted"] || false
              )
            end
          end
        )
      end
    end
  end
end
