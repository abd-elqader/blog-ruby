class PostDeletionJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find_by(id: post_id)
    
    if post
      Rails.logger.info "Deleting post ##{post_id} with title: #{post.title} after 24 hours"
      post.destroy
    else
      Rails.logger.info "Post ##{post_id} not found for deletion"
    end
  end
end