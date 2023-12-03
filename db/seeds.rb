# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Crear usuarios de prueba
user1 = User.create!(email: 'testuser1@example.com',username: "test1", password: 'password', password_confirmation: 'password')
user2 = User.create!(email: 'testuser2@example.com',username: "test2", password: 'password', password_confirmation: 'password')
# Añade más usuarios según sea necesario
# Crear links de prueba
link1 = Link.create!(url: 'https://example1.com', user: user1)
link2 = Link.create!(url: 'https://example2.com', user: user2)
# Añade más links según sea necesario
# Simular accesos a los links
10.times do |i|
    LinkAccess.create!(link: link1, accessed_at: Time.current - i.days, ip_address: "192.168.1.#{i}")
    LinkAccess.create!(link: link2, accessed_at: Time.current - i.days, ip_address: "192.168.2.#{i}")
end
  