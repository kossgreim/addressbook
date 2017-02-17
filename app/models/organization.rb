class Organization < ApplicationRecord
  include Paginatable

  has_many :users, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { in: 2..50 }
end
