class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_secure_password
  has_many :posts
  has_many :comments

  before_save :downcase_nickname

  validates :email, presence: true, uniqueness: true

  def downcase_nickname
    nickname.downcase!
  end
end
