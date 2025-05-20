class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes :id, :name, :email, :image_url, :created_at, :updated_at
  
  def image_url
    if object.image.attached?
      rails_blob_url(object.image)
    end
  end
end