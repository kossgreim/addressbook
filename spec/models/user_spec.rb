require 'rails_helper'

RSpec.describe Organization, type: :model do

  describe 'validation' do

    context 'when valid' do
      it 'creates a new user' do
        expect{ create(:user) }.to change(User, :count).by(+1)
      end
    end

    context 'when invalid' do

      let(:long_str) { Faker::Lorem.characters(60) }

      it 'has empty first name' do
        expect(build(:user, first_name: '')).to be_invalid
      end

      it 'has empty last name' do
        expect(build(:user, last_name: '')).to be_invalid
      end

      it 'has empty email' do
        expect(build(:user, email: '')).to be_invalid
      end

      it 'has invalid email' do
        expect(build(:user, email: '123')).to be_invalid
      end

      it 'has not unique email' do
        user = create(:user)
        expect(build(:user, email: user.email)).to be_invalid
      end

      it 'has first name larger than 50 symbols' do
        expect(build(:user, first_name: long_str)).to be_invalid
      end

      it 'has last name larger than 50 symbols' do
        expect(build(:user, last_name: long_str)).to be_invalid
      end

      it 'has first name shorter than 2 symbols' do
        expect(build(:user, first_name: '1')).to be_invalid
      end

      it 'has last name shorter than 2 symbols' do
        expect(build(:user, last_name: '1')).to be_invalid
      end

      it 'is not associated with an organization' do
        expect(build(:user, organization_id: nil)).to be_invalid
      end
    end
  end
end