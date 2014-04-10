require 'spec_helper'

describe 'TransactionFinder' do
  before :all do
    @budget = FactoryGirl.create(:budget)
  end

  describe 'sorting' do
    describe 'setting the sort options' do
      it "is correct if sorting option is in the list" do
        transaction_sorter = TransactionFinder.new(@budget,{},"category")
        expect(transaction_sorter.sorting).to eq(:category)
      end

      it "is set the sorting correctly if sorting options is not in the list" do
        transaction_sorter = TransactionFinder.new(@budget,{},"foobar")
        expect(transaction_sorter.sorting).not_to eq(:foobar)
      end

      it "is set the sorting correctly if sorting options is nil" do
        transaction_sorter = TransactionFinder.new(@budget,{},nil)
        expect(transaction_sorter.sorting).not_to eq(:foobar)
      end
    end

    describe 'sorting the transactions' do
      before :each do
        @category1 = FactoryGirl.create(:category, :name => "1. Stelle")
        @category2 = FactoryGirl.create(:category, :name => "2. Stelle")

        @user1 = FactoryGirl.create(:user, :name => "A")
        @user2 = FactoryGirl.create(:user, :name => "B")

        @first = FactoryGirl.create(:transaction, :date => 2.days.ago, :category => @category2, :user => @user1, :budget => @budget)
        @second = FactoryGirl.create(:transaction, :date => 3.days.ago, :category => @category1, :user => @user2, :budget => @budget)
        @third = FactoryGirl.create(:transaction, :date => 1.day.ago, :category => @category2, :user => @user2, :budget => @budget)
      end

      it 'sorts the transactions by category' do
        transaction_sorter = TransactionFinder.new(@budget, {}, :category)
        expect(transaction_sorter.transactions).to eq [@second,@third,@first]
      end

      it 'sorts the transactions by user' do
        transaction_sorter = TransactionFinder.new(@budget, {}, :user)
        expect(transaction_sorter.transactions).to eq [@first, @third, @second]
      end

      it 'sorts the transactions by date' do
        transaction_sorter = TransactionFinder.new(@budget, {}, :date)
        expect(transaction_sorter.transactions).to eq [@third, @first, @second]
      end
    end
  end

  describe 'filtering' do

    before :each do
      @category1 = FactoryGirl.create(:category, :name => "1")
      @category2 = FactoryGirl.create(:category, :name => "2")
      @category3 = FactoryGirl.create(:category, :name => "3")

      @first = FactoryGirl.create(:transaction, :category => @category1, :budget => @budget)
      @second = FactoryGirl.create(:transaction, :category => @category1, :budget => @budget)
      @third = FactoryGirl.create(:transaction, :category => @category2, :budget => @budget)
      @forth = FactoryGirl.create(:transaction, :category => @category3, :budget => @budget)
    end
    context 'by category' do
      it 'selects the right transactions if filter is set' do
        transaction_finder = TransactionFinder.new(@budget, [@category1.id, @category2.id])
        expect(transaction_finder.transactions.to_a - [@third,@second,@first]).to eql []
      end

      it 'selects all transactions if filter is empty' do
        transaction_finder = TransactionFinder.new(@budget, [])
        expect(transaction_finder.transactions.to_a - Transaction.all).to eql []
      end
    end
  end

end