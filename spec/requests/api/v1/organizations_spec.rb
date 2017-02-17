require 'rails_helper'

RSpec.describe 'organizations API', type: :request do
  # initialize test data
  let!(:organizations) { create_list(:organization, 5) }
  let(:organization_id) { organizations.first.id.to_s }
  let(:user) { create(:user, organization: organizations.first) }
  let(:admin) { create(:admin, organization: organizations.first) }

  # Test suite for GET /v1/organizations
  describe 'GET /v1/organizations' do
    # make HTTP get request before each example
    before do
      get v1_organizations_path, headers: authorized_json_request(admin)
    end

    it 'returns organizations' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json['data'].size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /v1/organizations/:id
  describe 'GET /v1/organizations/:id' do
    before do
      get "/v1/organizations/#{organization_id}",  headers: authenticated_request(admin)
    end

    context 'when the record exists' do
      it 'returns the organization' do
        expect(json['data']).to be_present
        expect(json['data']['id']).to eq(organization_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:organization_id) { 10013123123123131231231 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Organization/)
      end
    end
  end

  # Test suite for POST /v1/organizations
  describe 'POST /v1/organizations' do
    # valid payload
    let(:valid_attributes) { attributes_for(:organization) }

    context 'when the request is valid' do
      before do
        post '/v1/organizations',
             params: create_request('organizations', valid_attributes),
             headers: authenticated_request(admin)
      end

      it 'creates a organization' do
        expect(response_attribute('name')).to eq(valid_attributes[:name])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/v1/organizations',
             params: create_request('organizations', { name: '1' }),
             headers: admin.create_new_auth_token
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['errors']).to be_present
      end
    end
  end

  # Test suite for PATCH /v1/organizations/:id
  describe 'PATCH /v1/organizations/:id' do
    let(:valid_attributes) { attributes_for(:organization) }

    context 'when the record exists' do
      before do
        patch "/v1/organizations/#{organization_id}",
            params: create_request('organizations', valid_attributes),
            headers: authenticated_request(admin)
      end

      it 'updates the record' do
        expect(json['data']['attributes']).to eq(valid_attributes.stringify_keys)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /v1/organizations/:id
  describe 'DELETE /v1/organizations/:id' do
    before do
      delete "/v1/organizations/#{organization_id}", headers: admin.create_new_auth_token
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  # Test suit when user is not authorized to perform action
  describe 'Unauthorized requests' do
    context 'GET /v1/organizations/:id' do
      before { get v1_organization_path(organizations.first), headers: authenticated_request(user) }

      include_examples 'unauthorized request'
    end

    context 'POST /v1/organizations' do
      before { post v1_organizations_path, headers: authenticated_request(user) }

      include_examples 'unauthorized request'
    end

    context 'PATCH /v1/organizations/:id' do
      before { patch v1_organization_path(organizations.first), headers: authenticated_request(user) }

      include_examples 'unauthorized request'
    end

    context 'DELETE /v1/organizations/:id' do
      before { delete v1_organization_path(organizations.first), headers: authenticated_request(user) }

      include_examples 'unauthorized request'
    end
  end

  # Test suit to test unauthenticated (when user is not signed in)
  describe 'Unauthenticated requests' do
    context 'GET /v1/organizations/:id' do
      before { get v1_organization_path(organizations.first) }

      include_examples 'unauthenticated request'
    end

    context 'POST /v1/organizations' do
      before { post v1_organizations_path }

      include_examples 'unauthenticated request'
    end

    context 'PATCH /v1/organizations/:id' do
      before { patch v1_organization_path(organizations.first) }

      include_examples 'unauthenticated request'
    end

    context 'DELETE /v1/organizations/:id' do
      before { delete v1_organization_path(organizations.first) }

      include_examples 'unauthenticated request'
    end
  end
end