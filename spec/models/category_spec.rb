require 'spec_helper'

describe Category do
  it_behaves_like "has unique color"
		
	before :each do
		@category = FactoryGirl.create(:category, :name => 'Test')
	end

	it "has the sum of all associated transactions in this month as used_this_month" do
		transaction1 = FactoryGirl.create(:transaction, :comment => 'Transaction 1', :amount => 10, :category => @category)
		transaction2 = FactoryGirl.create(:transaction, :comment => 'Transaction 2', :amount => 20, :category => @category)
		transaction3 = FactoryGirl.create(:transaction, :comment => 'Transaction 3', :amount => 30, :category => @category)
		transaction4 = FactoryGirl.create(:transaction, :comment => 'Transaction 4', :amount => 40, :date => ( Time.now - 2.months ), :category => @category)

   	expect(@category.used_this_month).to eq(transaction1.amount + transaction2.amount + transaction3.amount)
  end
end
