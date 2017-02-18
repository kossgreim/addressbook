class ContactService

  def initialize(args={})
    # initializes Firebase database's url
    base_uri = args[:base_uri] || ENV['FIREBASE_DATABASE_URL']
    # setting the database's secret key
    secret_key = args[:secret_key] || ENV['FIREBASE_API_KEY']
    # collection name in the database
    @path = args[:collection_name] || 'contacts'

    @client = Firebase::Client.new(base_uri, secret_key)
  end

  # creates a new record
  def create(contact, organization_id)
    path = get_path(organization_id)
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

  # finds record by it's id
  def find(organization_id, id)
    path = get_path(organization_id, id)
    contact = handle_response(@client.get(path))
    raise ActiveRecord::RecordNotFound.new("Couldn't find Contact with id=#{id}") unless contact.present?

    set_contact_data(contact, id)
  end

  # finds all records for an organization
  def find_by_organization(organization_id, args={})
    path = get_path(organization_id)
    contacts = handle_response(@client.get(path, args))

    # return an empty array if didn't get any contacts
    return [] unless contacts

    # Wrap each item with Contact
    contacts.each_with_object([]) do |(id, contact), arr|
      arr << set_contact_data(contact, id)
    end
  end

  private

  # handles firebase database's response
  def handle_response(response)
    response.body if response.success?
  end

  # wraps data with Contact model
  def set_contact_data(attributes, id)
    Contact.new(attributes.merge({ id: id }))
  end

  # generates path for Firebase database's records
  def get_path(organization_id, id = nil)
    path = "#{@path}/organization_#{organization_id}"
    path << "/#{id}" if id

    path
  end
end