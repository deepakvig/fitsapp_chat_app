# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create(email: 'admin@example.com', password: 'password')
admin.is_admin = true
admin.save

trainer = User.create(email: 'trainer@example.com', password: 'password', role: 1)
user = User.create(email: 'user@example.com', password: 'password', role: 0)