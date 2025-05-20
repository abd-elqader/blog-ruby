class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  
  belongs_to :author, serializer: UserSerializer
  has_many :comments
  has_many :tags
end