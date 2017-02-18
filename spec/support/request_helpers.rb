module Requests

  module JsonHelpers

    def json
      JSON.parse(response.body)
    end
  end

  module JsonAPI

    def create_request(type, attributes)
      {
          data: { type: type, attributes: attributes }
      }
    end

    def response_attribute(name)
      json['data']['attributes'][name]
    end
  end

  module Headers

    def authenticated_request(user)
      user.create_new_auth_token
    end

    def authorized_json_request(user)
      authenticated_request(user).merge({'Content-Type' => 'application/vnd.api+json' })
    end
  end

  module Contacts
    def create_contact
      service = ContactService.new
      contact = Contact.new(attributes_for(:contact))
      service.create(contact, contact.organization_id)
    end
  end
end