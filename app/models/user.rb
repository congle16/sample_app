class User < ApplicationRecord
  attr_accessor :remember_token
  before_save{self.email = email.downcase}
  validates :name, presence: true,
  length: {maximum: Settings.length.digit_50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true,
            length: {maximum: Settings.length.digit_50},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true
  has_secure_password
  validates :password,
            presence: true,
            length: {minimum: Settings.length.digit_6},
            allow_nil: true

  class << self
    # returns the hash digest of the given string
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    # return a random token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # remember a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  # returns true if the given token matches the digest
  def authenticated? remember_token
    BCrypt::Password.new(remember_token).is_password?(remember_token)
  end

  # forgets a user
  def forget
    update_attribute :remember_digest, nil
  end
end
