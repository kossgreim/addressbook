module ServiceHelpers
  module ContactService

    def create_contact
      VCR.use_cassette('firebase/contacts/create') do
        contact = Contact.new(attributes_for(:contact))
        @created_contact = @service.create(contact, contact.organization_id)
      end

      @created_contact
    end

    def find_contact(contact)
      VCR.use_cassette('firebase/contacts/find') do
        @finding_contact = @service.find(contact.organization_id, contact.id)
      end

      @finding_contact
    end
  end
end