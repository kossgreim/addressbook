require 'rails_helper'

RSpec.describe 'ContactService', type: :service do

  before(:all) do
    @service = ContactService.new
  end

  describe '#create' do

    before(:all) do
      VCR.use_cassette('firebase/contacts/create') do
        contact = Contact.new(attributes_for(:contact))
        @result = @service.create(contact, contact.organization_id)
      end
    end

    it 'returns data wrapped in Contact model' do
      expect(@result).to be_a(Contact)
    end

    it 'has :id attribute set' do
      expect(@result.id).to be_present
    end
  end

  describe '#update' do
    before(:all) do
      @created_contact = create_contact

      VCR.use_cassette('firebase/contacts/update') do
        @created_contact.attributes = attributes_for(:contact, first_name: 'Robert')
        @result = @service.update(@created_contact, @created_contact.organization_id, @created_contact.id)
      end
    end

    it 'returns data wrapped in Contact model' do
      expect(@result).to be_a(Contact)
    end

    it 'updates contact' do
      expect(@result.attributes).to eq(@created_contact.attributes)
    end
  end

  describe '#find' do

    before(:all) do
      @created_contact = create_contact

      @finding_contact = find_contact(@created_contact)
    end

    context 'when contact exists' do

      it 'finds a Contact' do
        expect(@finding_contact).to be_a(Contact)
      end

      it 'should a with the same id' do
        expect(@finding_contact.id).to eq(@created_contact.id)
      end
    end

    context 'when contact does not exist' do

      it 'raises ActiveRecord::RecordNotFound' do
        VCR.use_cassette('firebase/contacts/find_not_found') do
          expect { @service.find(123, 123) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe '#destroy' do

    before(:all) do
      @created_contact = create_contact
    end

    it 'returns true when record is deleted' do
      VCR.use_cassette('firebase/contacts/destroy') do
        result = @service.destroy(@created_contact.organization_id, @created_contact.id)
        expect(result).to be_truthy
      end
    end
  end

  describe '#find_by_organization' do

    context 'when organization exists' do

      before(:all) do
        VCR.use_cassette('firebase/contacts/find_by_organization') do
          @collection = @service.find_by_organization(1)
        end
      end

      it 'finds a collection of contacts' do
        expect(@collection).to be_a(Array)
      end

      it 'collection with more than one record' do
        expect(@collection.size).to be > 1
      end

      it 'each record should be a Contact' do
        expect(@collection).to all( be_a(Contact) )
      end
    end

    context 'when organization does not exist' do
      it 'returns an empty collection' do
        VCR.use_cassette('firebase/contacts/find_by_organization_that_doesnt_exist') do
          expect(@service.find_by_organization(1333)).to eq([])
        end
      end
    end
  end
end