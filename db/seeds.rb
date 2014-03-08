# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
User.create(
	[
		{
			name: 'admin',
			admin: true,
			email: 'admin@local.host',
			password: 'password',
			password_confirmation: 'password',
		},
		{
			name: 'user',
			admin: false,
			email: 'user@local.host',
			password: 'password',
			password_confirmation: 'password',
		},
	]
)
