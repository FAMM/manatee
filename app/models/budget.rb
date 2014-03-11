class Budget < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :categories, :dependent => :destroy
  has_many :transactions, :through => :categories

  def saldo
    -1
  end


  def saldo_in_percent
    -1
  end
end

