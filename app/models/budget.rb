class Budget < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  has_many :categories, :dependent => :destroy
  has_many :transactions

  attr_accessor :planned, :used_this_month

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :currency, presence: true
  validates :creator_id, presence: true
  validate :valid_user_count
  validate :validate_creator_is_member

  def used_this_month
		self.categories.map(&:used_this_month).inject(&:+)
  end

  def planned
		self.categories.sum(:planned)
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

  def validate_creator_is_member
    return false unless creator
    errors.add(:base, :creator_must_be_a_member) unless creator.in?(users)
  end
end
