# frozen_string_literal: true

class FolderCreateAction < Upgrow::Action
  include Shared::FolderValidation
  result :folder

  def perform(params)
    input = FolderInput.new(params)

    if input.valid?
      return result.failure('Parent folder not exists') if folder_parent_valid?(input)

      folder = FolderRepository.create(input)
      result.success(folder: folder)
    else
      result.failure(input.errors)
    end
  end
end
