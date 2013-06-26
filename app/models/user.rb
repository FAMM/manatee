class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :categories
  has_many :transactions

  LANGUAGES={"English" => "en", "Deutsch" => "de", "Svenska" => "se"}

	def saldo date=nil
					if date
									# get the saldo of the latest transaction on a certain day
									first_transaction = self.transactions.where(date: date).order("date DESC").first
									return first_transaction.saldo + first_transaction.amount
					else
									# return the saldo of the very last transaction
									return self.transactions.order("date DESC").first.saldo
					end
	end
end
