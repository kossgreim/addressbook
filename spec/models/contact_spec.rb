require 'rails_helper'

RSpec.describe Organization, type: :model do

  describe 'validation' do

    context 'when has valid data' do
      it 'should be valid' do
        expect(build(:contact)).to be_valid
      end
    end

    context 'invalid when' do

      let(:long_text) { Faker::Lorem.characters(60) }

      it 'has empty first name' do
        expect(build(:contact, first_name: nil)).to be_invalid
      end

      it 'has empty last name' do
        expect(build(:contact, last_name: nil)).to be_invalid
      end

      it 'has invalid email' do
        expect(build(:contact, email: '123')).to be_invalid
      end

      it 'has first name shorter than 2 symbols' do
        expect(build(:contact, first_name: 'a')).to be_invalid
      end

      it 'has last name shorter than 2 symbols' do
        expect(build(:contact, last_name: 'b')).to be_invalid
      end

      it 'has first name longer than 50 symbols' do
        expect(build(:contact, first_name: long_text)).to be_invalid
      end

      it 'has last name longer that 50 symbols' do
        expect(build(:contact, last_name: long_text)).to be_invalid
      end

      it 'has phone shorter that 8 symbols' do
        expect(build(:contact, phone: '1234')).to be_invalid
      end

      it 'has phone longer that 25 symbols' do
        long_phone = Faker::Number.number(30)
        expect(build(:contact, phone: long_phone)).to be_invalid
      end

      it 'has no author' do
        expect(build(:contact, author_id: nil)).to be_invalid
      end

      it 'has no organization' do
        expect(build(:contact, organization_id: nil)).to be_invalid
      end
    end
  end
end