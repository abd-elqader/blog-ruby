class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  
  validates :title, presence: true
  validates :body, presence: true
  validates :tags, presence: true
  validate :has_at_least_one_tag
  
  after_create :schedule_deletion
  
  private
  
  def has_at_least_one_tag
    errors.add(:tags, "must have at least one tag") if tags.empty?
  end
  
  def schedule_deletion
    PostDeletionJob.set(wait: 24.hours).perform_later(id)
  end
end