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
  ##
  before_create :generate_confirmation_instructions
  ###
  #   PASSWORD_FORMAT = /\A
  #   (?=.{8,})          # Must contain 8 or more characters
  #   (?=.*\d)           # Must contain a digit
  #   (?=.*[a-z])        # Must contain a lower case character
  #   (?=.*[A-Z])        # Must contain an upper case character
  #   (?=.*[[:^alnum:]]) # Must contain a symbol
  # /x
  # validates :password, length: { minimum: 7 },
  #                      format: { with: PASSWORD_FORMAT }
  ###
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

  ## Sends activation email

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Tao token
  def generate_confirmation_instructions
    self.confirmation_token = SecureRandom.hex(10)
    self.confirmation_sent_at = Time.now.utc
  end
  ## time +30d
  def confirmation_token_valid?
    (confirmation_sent_at + 30.days) > Time.now.utc
  end

end
