# Create 2 Users, on is an admin the other one a user (automatically creates user budgets)
admin,user = User.create!(
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



# Create another budget that is shared between both users
Budget.create!(
    :name => "Shared Budget",
    :description => "This is a shared Budget between admin and user",
    :users => User.all,
		:creator => admin
)

# Create 3 categories for every budget
Budget.all.each do |budget|
  3.times do |i|
    budget.categories.create!(
        :name => "Category #{i+1}",
        :planned => (i+1)*100
    )
  end
end

#Add some transactions
admin.budgets.each do |budget|
  categories = budget.categories
  budget.transactions.create!([
    {
        :amount => 10,
        :comment => "Foo Bar",
        :date => Date.today,
        :category => categories[0],
        :user => admin
    },
    {
        :amount => 69,
        :comment => "The quick brown fox...",
        :date => Date.today,
        :category => categories[1],
        :user => admin
    },
    {
        :amount => 486,
        :comment => "unexpected costs",
        :date => Date.today,
        :category => categories[2],
        :user => admin
    }
  ])
end

user.budgets.each do |budget|
  categories = budget.categories
  budget.transactions.create!([
    {
        :amount => 48,
        :comment => "Foo Bar",
        :date => Date.today,
        :category => categories[0],
        :user => user
    },
    {
        :amount => 10,
        :comment => "The quick brown fox...",
        :date => Date.today,
        :category => categories[1],
        :user => user
    },
    {
        :amount => 5,
				:comment => "Bar Baz",
        :date => Date.today,
        :category => categories[2],
        :user => user
    }
  ])
end
