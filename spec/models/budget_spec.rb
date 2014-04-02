require 'spec_helper'

describe 'Budget' do
	before :each do
		@user = FactoryGirl.create(:user, :name => 'Test')
		@budget = FactoryGirl.create(:budget)
	end

  it "has the sum of all planned money for all associated categories" do
		category1 = FactoryGirl.create(:category, :name => "Category 1", :planned => 100, :budget => @budget)
		category2 = FactoryGirl.create(:category, :name => "Category 2", :planned => 200, :budget => @budget)
		category3 = FactoryGirl.create(:category, :name => "Category 3", :planned => 300, :budget => @budget)
		
    expect(@budget.planned).to eq(category1.planned + category2.planned + category3.planned)
  end
   
	it "has the sum of all associated categories' used_this_month as used_this_month" do
		category1 = FactoryGirl.create(:category, :name => "Category 1", :planned => 100, :budget => @budget)
		category2 = FactoryGirl.create(:category, :name => "Category 2", :planned => 200, :budget => @budget)
		category3 = FactoryGirl.create(:category, :name => "Category 3", :planned => 300, :budget => @budget)
		
		transaction1 = FactoryGirl.create(:transaction, :comment => 'Transaction 1', :amount => 10, :category => category1)
 		transaction2 = FactoryGirl.create(:transaction, :comment => 'Transaction 2', :amount => 20, :category => category2)
 		transaction3 = FactoryGirl.create(:transaction, :comment => 'Transaction 3', :amount => 30, :category => category3)
 		transaction4 = FactoryGirl.create(:transaction, :comment => 'Transaction 4', :amount => 40, :date => ( Time.now - 2.months ), :category => category1)
   		
		expect(@budget.used_this_month).to eq(transaction1.amount + transaction2.amount + transaction3.amount)
	end
end
