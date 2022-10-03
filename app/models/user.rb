class User < ApplicationRecord
  has_secure_password
  has_many :builds

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email, :password, presence: true
  validates :email, uniqueness: true
end
