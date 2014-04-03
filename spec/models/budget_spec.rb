require 'spec_helper'

describe 'Budget' do

  describe "validating" do
    it "is valid if there is at least one user" do
      budget = FactoryGirl.build(:budget, :users => [FactoryGirl.create(:user)])
      expect(budget.valid?).to be true
    end

    it "is invalid if there is no user associated" do
      budget = FactoryGirl.build(:budget, :users => [])
      expect(budget.valid?).not_to be true
    end

    it "is invalid if there is more than one user and the budget is single user" do
      budget = FactoryGirl.build(:budget, :users => [FactoryGirl.create(:user), FactoryGirl.create(:user)], :single_user => true)
      expect(budget.valid?).not_to be true
    end

  end



  describe "setting user ids from user_id_list" do
    it "converts the user_ids to a comma separated string" do
      budget = FactoryGirl.create(:budget, :users => [FactoryGirl.create(:user),FactoryGirl.create(:user)])

      user_id_list = budget.user_id_list
      users_on_list = User.find(user_id_list.split(','))

      expect(users_on_list - budget.users).to eql []
    end

    it "sets the users according to the user id list" do
      budget = FactoryGirl.build(:budget)
      existing_user = budget.users.first
      new_user = FactoryGirl.create(:user)
      users = [existing_user,new_user]

      budget.user_id_list = users.map(&:id).join(",")
      expect(budget.users - users).to eql []
    end

  end

  describe "calculating planned and used ammount" do
    before :each do
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

    it "has the difference between planned and used_this_month as saldo" do
      category1 = FactoryGirl.create(:category, :name => "Category 1", :planned => 100, :budget => @budget)
      category2 = FactoryGirl.create(:category, :name => "Category 2", :planned => 200, :budget => @budget)
      category3 = FactoryGirl.create(:category, :name => "Category 3", :planned => 300, :budget => @budget)

      transaction1 = FactoryGirl.create(:transaction, :comment => 'Transaction 1', :amount => 10, :category => category1)
      transaction2 = FactoryGirl.create(:transaction, :comment => 'Transaction 2', :amount => 20, :category => category2)
      transaction3 = FactoryGirl.create(:transaction, :comment => 'Transaction 3', :amount => 30, :category => category3)
      transaction4 = FactoryGirl.create(:transaction, :comment => 'Transaction 4', :amount => 40, :date => ( Time.now - 2.months ), :category => category1)

      expect(@budget.saldo).to eq(@budget.planned - @budget.used_this_month)
    end
  end
end
