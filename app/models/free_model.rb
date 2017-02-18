class FreeModel
  include ActiveModel::Model
  include ActiveModel::Serialization

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

  # set attributes for model
  def set_attributes(attributes)
    attributes.each do |name, value|
      if respond_to?(name.to_sym)
        send("#{name}=", value)
        @attributes[name.to_sym] = value
      end
    end
  end
end