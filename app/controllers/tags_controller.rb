class TagsController < ApplicationController
  before_action :set_tag, only: [:show]

  # GET /tags
  def index
    @tags = Tag.all
    render json: @tags, status: :ok
  end

  # GET /tags/:id
  def show
    render json: @tag, include: :posts, status: :ok
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Tag not found" }, status: :not_found
  end
end