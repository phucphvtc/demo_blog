class User < ApplicationRecord
  before_save { self.email = email.downcase }
  has_secure_password
  has_many :builds
  has_many :likes

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # validates :email, :password, presence: true
  validates :email, presence: true, uniqueness: true
  # validates :password, presence: true

  validate :password_lower_case, if: -> { password.present? }
  validate :password_uppercase, if: -> { password.present? }
  validate :password_special_char, if: -> { password.present? }
  validate :password_contains_number, if: -> { password.present? }

  def password_uppercase
    return if !!password.match(/\p{Upper}/)

    errors.add :password, ' must contain at least 1 uppercase '
  end

  def password_lower_case
    return if !!password.match(/\p{Lower}/)

    errors.add :password, ' must contain at least 1 lowercase '
  end

  def password_special_char
    special = "?<>',?[]}{=-)(*&^%$#`~{}!"
    regex = /[#{special.gsub(/./) { |char| "\\#{char}" }}]/
    return if password =~ regex

    errors.add :password, ' must contain special character'
  end

  def password_contains_number
    return if password.count('0-9') > 0

    errors.add :password, ' must contain at least one number'
  end
end
