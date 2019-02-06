class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :recoverable, :rememberable
  devise :database_authenticatable, :registerable, :validatable

  validates :email, presence: true, uniqueness: true

  has_many :appointments, dependent: :delete_all

end
