class ContactSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :organization_id
end
