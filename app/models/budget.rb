class Budget < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :categories, :dependent => :destroy
  has_many :transactions

  attr_accessor :planned, :used_this_month

  def used_this_month
    used = 0.0

		self.categories.each do |category|
			used += category.used_this_month
		end
		
		used
  end

  def planned
    planned = 0.0

		self.categories.each do |category|
			planned += category.planned
		end
		
		planned
  end

  def saldo
    self.planned - self.used_this_month
  end
end

