class Like < ApplicationRecord
  belongs_to :user
  belongs_to :liketable, polymorphic: true

  # has_many :likes, as: :liketable, dependent: :destroy
end
