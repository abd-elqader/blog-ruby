class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
  
  belongs_to :author, serializer: UserSerializer
  belongs_to :post
end