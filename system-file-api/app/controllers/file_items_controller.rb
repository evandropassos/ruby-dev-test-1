# frozen_string_literal: true

class FileItemsController < ApplicationController
  def create
    FileItemCreateAction.new.perform(params[:folder_id], file_item_params)
                        .and_then { |file_item:| render json: FileItemSerializer.render_as_hash(file_item), status: :created }
                        .or_else { |errors| render json: { errors: errors }, status: :unprocessable_entity }
  end

  def update
    FileItemUpdateAction.new.perform(params[:id], params[:folder_id], file_item_params)
                        .and_then { |file_item:| render json: FileItemSerializer.render_as_hash(file_item), status: :ok }
                        .or_else { |errors| render json: { errors: errors }, status: :unprocessable_entity }
  end

  def destroy
    FileItemDeleteAction.new.perform(params[:id])
    head :no_content
  end

  def index
    FileItemListAction.new.perform(params[:folder_id]).and_then do |file_items:|
      render json: FileItemSerializer.render_as_hash(file_items)
    end
  end

  private

  def file_item_params
    params.permit(:name, :content)
  end
end
