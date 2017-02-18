class Contact < FreeModel
  attr_accessor :id, :first_name, :last_name, :email, :phone, :organization_id, :author_id

  validates :first_name, :last_name, presence: true, length: { in: 2..50 }
  validates_format_of :email, :with => /@/
  validates :phone, length: { in: 8..25 }, allow_blank: true
  validates_numericality_of :organization_id, :author_id, only_integer: true

end