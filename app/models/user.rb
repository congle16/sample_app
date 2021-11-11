class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true,
            length: {maximum: 50},
            uniqueness: true
  validates :password, presence: true

  has_secure_password
end
