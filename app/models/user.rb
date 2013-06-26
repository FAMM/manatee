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
									return 0
					else
									# return the saldo of the very last transaction
									return 0
					end
	end
end
