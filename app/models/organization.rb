class Organization < ApplicationRecord
  include Paginatable

  validates :name, presence: true, uniqueness: true, length: { in: 2..50 }
end
