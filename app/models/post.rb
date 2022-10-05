class Post < ApplicationRecord
  belongs_to :user
  validates :title, :content, presence: true

  # comment table
  # Xoa post thi xoa cmt
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :likes, as: :liketable
end
