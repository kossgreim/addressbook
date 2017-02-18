FactoryGirl.define do
  factory :contact do
    first_name 'John'
    last_name 'Smith'
    email 'john@smith123.corp'
    phone '444433322556'
    author_id 1
    organization_id 2
  end
end