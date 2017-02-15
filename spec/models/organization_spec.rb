require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'validation' do
    context 'when valid' do
      it 'creates a new record' do
        expect{ create(:organization) }.to change(Organization, :count).by(+1)
      end
    end

    context 'when invalid' do
      it 'has an empty name' do
        expect(build(:organization, name: nil)).to be_invalid
      end

      it 'has name larger than 50 symbols' do
        long_name = Faker::Lorem.characters(55)
        expect(build(:organization, name: long_name)).to be_invalid
      end

      it 'has name with fewer than 2 symbols' do
        expect(build(:organization, name: '1')).to be_invalid
      end

      it 'has name that already exists' do
        duplicate_organization = create(:organization)
        expect(build(:organization, name: duplicate_organization.name)).to be_invalid
      end
    end
  end
end
