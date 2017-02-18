class Contact
  include ActiveModel::Model
  include ActiveModel::Serialization
  attr_accessor :id, :first_name, :last_name, :email, :phone, :organization_id

  def attributes
    @attributes
  end

  def attributes=(attributes)
    set_attributes(attributes)
  end

  def initialize(attributes = {})
    @attributes = {}

    set_attributes(attributes)
  end

  private

  def set_attributes(attributes)
    attributes.each do |name, value|
      if respond_to?(name.to_sym)
        send("#{name}=", value)
        @attributes[name.to_sym] = value
      end
    end
  end
end