# frozen_string_literal: true

class FolderRepository
  class << self
    def all
      FolderRecord.all.map do |record|
        to_folder_model(record.attributes)
      end
    end

    def create(input)
      record = FolderRecord.create!(input.to_hash)
      to_folder_model(record.attributes)
    end

    def exists(id)
      FolderRecord.where(id: id).presence
    end

    def find(id)
      record = FolderRecord.find(id)
      to_folder_model(record.attributes)
    end

    def find_with_childrens_and_files(id)
      record = FolderRecord.find(id)
      childrens = childrens(id)
      file_items = FileItemRepository.list_by_folder(id)

      to_folder_model(record.attributes.merge(childrens: childrens, file_items: file_items))
    end

    def childrens(id)
      records = FolderRecord.where(folder_id: id).order(:name)
      records.map do |item|
        to_folder_model(item.attributes)
      end
    end

    def update(id, input)
      record = FolderRecord.find(id)
      record.update!(input.to_hash)
      to_folder_model(record.attributes)
    end

    def delete(id)
      record = FolderRecord.find(id)
      record.destroy!
    end

    def to_folder_model(attributes)
      Folder.new(**attributes.symbolize_keys)
    end
  end
end
