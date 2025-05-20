class User < ApplicationRecord
  has_secure_password
  has_many :posts, foreign_key: "author_id", dependent: :destroy
  has_many :comments, foreign_key: "author_id", dependent: :destroy
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_digest_changed?
  
  # Validate email format
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  
  # Add image attachment (requires Active Storage setup)
  has_one_attached :image
end