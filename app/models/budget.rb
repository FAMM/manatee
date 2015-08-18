class Budget < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :categories, :dependent => :destroy
  has_many :transactions

  attr_accessor :planned, :used_this_month

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validate :valid_user_count

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

  def user_id_list
    users.map(&:id).join(",")
  end

  def user_id_list=(list)
    self.users = User.where(:id => list.split(','))
  end


  private

  def valid_user_count
    if single_user?
      errors.add(:base, :too_many_users) if user_ids.count != 1
    else
      errors.add(:base, :too_few_users) if user_ids.count < 1
    end
    false
  end
end

