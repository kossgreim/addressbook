class User < ActiveRecord::Base

  include DeviseTokenAuth::Concerns::User
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization

  validates :first_name, :last_name, length: { in: 2..50 }, presence: true
  validates_associated :organization
  validates_presence_of :organization
end
