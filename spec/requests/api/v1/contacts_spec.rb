require 'rails_helper'

RSpec.describe 'organizations API', type: :request do
  # initialize test data
  let(:org) {create(:organization) }
  let(:org_id) { 1 }
  let(:user) { create(:user, organization: org) }

  # Test suite for GET /v1/organizations
  describe 'GET /v1/organizations/:id/contacts' do
    # make HTTP get request before each example
    before do
      VCR.use_cassette('api/v1/get/contacts', record: :new_episodes) do
        get v1_organization_contacts_path(organization_id: org.id), headers: authorized_json_request(user)
      end
    end

    it 'returns organizations' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /v1/organizations/:organization_id/contact/:id
  describe 'GET /v1/organizations/:organization_id/contact/:id' do

    context 'when the record exists' do

      before do
        VCR.use_cassette('api/v1/get/contacts_show', record: :new_episodes) do
          @contact = create_contact
          get "/v1/organizations/#{@contact.organization_id}/contacts/#{@contact.id}",
              headers: authenticated_request(user)
        end
      end

      it 'returns the organization' do
        expect(json['data']).to be_present
        expect(json['data']['id']).to eq(@contact.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do

      before do
        VCR.use_cassette('api/v1/get/contacts_show', record: :new_episodes) do
          @contact = create_contact
          get "/v1/organizations/#{@contact.organization_id}/contacts/123123123123",
              headers: authenticated_request(user)
        end
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Contact with id=123123123123/)
      end
    end
  end

  # # Test suite for POST /v1/organizations/:organization_id/contacts
  describe 'POST /v1/organizations/:organization_id/contacts' do
    # valid payload
    let(:valid_attributes) { attributes_for(:contact) }

    context 'when the request is valid' do
      before do
        VCR.use_cassette('api/v1/post/contacts', record: :new_episodes) do
          post "/v1/organizations/#{org.id}/contacts",
               params: create_request('contacts', valid_attributes),
               headers: authenticated_request(user)
        end
      end

      it 'creates a contact' do
        expect(response_attribute('name')).to eq(valid_attributes[:name])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        VCR.use_cassette('api/v1/post/contacts', record: :new_episodes) do
          post "/v1/organizations/#{org.id}/contacts",
               params: create_request('contacts', {name: '1'}),
               headers: authenticated_request(user)
        end
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['errors']).to be_present
      end
    end
  end

  # Test suite for PATCH /v1/organizations/:organization_id/contacts/:id'
  describe 'PATCH /v1/organizations/:organization_id/contacts/:id' do
    let(:valid_attributes) { attributes_for(:contact) }

    context 'when the record exists' do
      before do
        VCR.use_cassette('api/v1/patch/contacts', record: :new_episodes) do
          @contact = create_contact
          patch "/v1/organizations/#{@contact.organization_id}/contacts/#{@contact.id}",
               params: create_request('contacts', {name: '1'}),
               headers: authenticated_request(user)
        end
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /v1/organizations/:organization_id/contacts/:id
  describe 'DELETE /v1/organizations/:organization_id/contacts/:id' do

    before do
      VCR.use_cassette('api/v1/delete/contacts', record: :new_episodes) do
        @contact = create_contact
        delete "/v1/organizations/#{@contact.organization_id}/contacts/#{@contact.id}",
              params: create_request('contacts', {name: '1'}),
              headers: authenticated_request(user)
      end
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  # Test suit to test unauthenticated (when user is not signed in)
  describe 'Unauthenticated requests' do

    context 'GET /v1/organizations/:organization_id/contacts' do
      before { get v1_organization_contacts_path(organization_id: org.id) }

      include_examples 'unauthenticated request'
    end

    context 'GET /v1/organizations/:organization_id/contacts/:id' do
      before { get v1_organization_contact_path(organization_id: org.id, id: 123) }

      include_examples 'unauthenticated request'
    end

    context 'POST /v1/organizations' do
      before { post v1_organization_contacts_path(organization_id: org.id) }

      include_examples 'unauthenticated request'
    end

    context 'PATCH /v1/organizations/:organization_id/contacts/:id' do
      before { patch v1_organization_contact_path(organization_id: org.id, id: 123) }

      include_examples 'unauthenticated request'
    end

    context 'DELETE /v1/organizations/:id' do
      before { delete v1_organization_contact_path(organization_id: org.id, id: 123) }

      include_examples 'unauthenticated request'
    end
  end
end