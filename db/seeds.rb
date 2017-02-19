# Creating admin and organization
org = Organization.new(name: 'First Organization Test')
org.save!
puts "Organization #{org.name} has been created"

admin = User.new(
    first_name: 'Admin',
    last_name: 'Admin',
    email: 'admin@example.com',
    password: '12345678',
    admin: true,
    organization_id: org.id
)
admin.save!

puts 'Test admin account has been created'
puts '-'*10
puts 'Your login: admin@example.com'
puts 'Your password: 12345678'

