class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true,
            length: {maximum: 50},
            uniqueness: true
  validates :password, presence: true

  has_secure_password

  # returns the hash digest of the given string
  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end
end
