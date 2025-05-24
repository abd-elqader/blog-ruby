class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:update, :destroy]
  
  # GET /posts
  def index
    @posts = Post.includes(:author, :tags, :comments).all
    render json: @posts
  end
  
  # GET /posts/1
  def show
    render json: @post
  end
  
  # POST /posts
  def create
    if params[:title].blank? || params[:body].blank?
      return render json: { error: 'Title and Body are required' }, status: :bad_request
    end
    @post = current_user.posts.new(post_params)
    
    # Process tags
    if params[:tags].present?
      tags = process_tags(params[:tags])
      @post.tags << tags
    end
    
    if @post.save
      # PostDeletionJob.set(wait: 24.hours).perform_later(@post.id)
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /posts/1
  def update
    if params[:title].blank? || params[:body].blank?
      return render json: { error: 'Title and Body are required' }, status: :bad_request
    end

    if @post.update(post_params)
      # Update tags if provided
      if params[:tags].present?
        @post.post_tags.destroy_all # Remove existing tags
        tags = process_tags(params[:tags])
        @post.tags << tags
      end
      
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /posts/1
  def destroy
    @post.destroy
    head :no_content
  end
  
  private
  
  def set_post
    @post = Post.includes(:author, :tags, :comments).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Post not found" }, status: :not_found
  end
  
  def authorize_user
    unless @post.author_id == current_user.id
      render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
    end
  end
  
  def post_params
    params.require(:post).permit(:title, :body)
  end
  
  def process_tags(tag_names)
    tag_names.map do |name|
      Tag.find_or_create_by(name: name.strip.downcase)
    end
  end
end