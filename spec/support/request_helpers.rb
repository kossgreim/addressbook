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
end