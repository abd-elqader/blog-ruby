class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:update, :destroy]
  
  # GET /posts/:post_id/comments
  def index
    @comments = @post.comments.includes(:author)
    render json: @comments
  end
  
  # GET /posts/:post_id/comments/:id
  def show
    render json: @comment
  end
  
  # POST /posts/:post_id/comments
  def create
    @comment = @post.comments.new(comment_params)
    @comment.author = current_user
    
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /posts/:post_id/comments/:id
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /posts/:post_id/comments/:id
  def destroy
    @comment.destroy
    head :no_content
  end
  
  private
  
  def set_post
    @post = Post.find(params[:post_id])
  end
  
  def set_comment
    @comment = @post.comments.find(params[:id])
  end
  
  def authorize_user
    unless @comment.author_id == current_user.id
      render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
    end
  end
  
  def comment_params
    params.require(:comment).permit(:body)
  end
end