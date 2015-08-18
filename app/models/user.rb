class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable

  has_and_belongs_to_many :budgets
  has_many :transactions

  has_many :filters, dependent: :delete_all

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  after_create :create_user_budget

  LANGUAGES={"English" => "en", "Deutsch" => "de", "Svenska" => "se"}

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  scope :find_by_name_or_email, lambda {|identifier| where(["lower(name) = :value OR lower(email) = :value", { :value => identifier}]).limit(1) }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def as_json(options={})
    {:id => id,:name => name}
  end

  def create_user_budget
    Budget.create(
			:name => self.name.capitalize,
			:description => "Budget for #{self.name}",
      :single_user => true,
      :users => [self]
		)
  end
end
