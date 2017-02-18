class ContactService

  def initialize(args={})
    base_uri = args[:base_uri] || ENV['FIREBASE_DATABASE_URL']
    secret_key = args[:secret_key] || ENV['FIREBASE_API_KEY']
    @path = args[:collection_name] || 'contacts'

    @client = Firebase::Client.new(base_uri, secret_key)
  end

  def create(contact)
    path = get_path(contact.organization_id)
    result = handle_response(@client.push(path, contact.attributes))
    return if result.blank?

    set_contact_data(contact.attributes, result['name'])
  end

  def update(contact, organization_id, id)
    path = get_path(organization_id, id)
    contact = handle_response(@client.update(path, contact.attributes))

    set_contact_data(contact, id)
  end

  def destroy(organization_id, id)
    path = get_path(organization_id, id)
    result = @client.delete(path)

    result.success?
  end

  def find(organization_id, id)
    path = get_path(organization_id, id)
    contact = handle_response(@client.get(path))
    raise ActiveRecord::RecordNotFound unless contact.present?

    set_contact_data(contact, id)
  end

  def find_by_organization(organization_id, args={})
    path = get_path(organization_id)
    contacts = handle_response(@client.get(path, args))
    arr = []
    contacts.each do |id, contact|
      arr << set_contact_data(contact, id)
    end

    arr
  end

  private

  def handle_response(response)
    return false unless response.success?

    response.body
  end

  def set_contact_data(attributes, id)
    Contact.new(attributes.merge({ id: id }))
  end

  def get_path(organization_id, id = nil)
    path = "#{@path}/organization_#{organization_id}"
    path << "/#{id}" if id

    path
  end
end