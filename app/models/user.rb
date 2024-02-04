class User < ApplicationRecord
  has_secure_password
  has_many :posts
  has_many :comments

  before_save :downcase_nickname

  validates :email, presence: true, uniqueness: true

  def downcase_nickname
    nickname.downcase!
  end
end
