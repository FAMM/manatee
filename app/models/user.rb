class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable

  has_many :categories, dependent: :delete_all
  has_many :transactions, dependent: :delete_all
	has_many :filters, dependent: :delete_all

  LANGUAGES={"English" => "en", "Deutsch" => "de", "Svenska" => "se"}

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login


  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def saldo
    # get how much is spend in the actual month
    spend = 0
    self.transactions.this_month.each do |t|
      spend += t.amount
    end

    # get how much is planned per month
    planned = 0
    self.categories.each do |c|
      planned += c.budget
    end

    # return how much is left
    return ( planned - spend )
  end

  def saldo_in_percent
    # get how much is spend in the actual month
    spend = 0
    self.transactions.this_month.each do |t|
      spend += t.amount
    end

    # get how much is planned per month
    planned = 0
    self.categories.each do |c|
      planned += c.budget
    end

    # return how much is left
    return ( spend / planned  )
  end
end
