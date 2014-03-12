class Budget < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :categories, :dependent => :destroy
  has_many :transactions, :through => :categories

  attr_accessor :planned, :used_this_month

  def used_this_month
    @used_this_month ||= planned*rand
  end

  def planned
    @planned ||= rand*1000.to_i
  end

  def saldo
    -1
  end


  def saldo_in_percent
    -1
  end
end

