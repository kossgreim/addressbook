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

    def authorized_request(user)
      user.create_new_auth_token
    end

    def authorized_json_request(user)
      authorized_request(user).merge({ 'Content-Type' => 'application/vnd.api+json' })
    end
  end
end