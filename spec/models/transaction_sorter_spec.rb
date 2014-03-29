require 'spec_helper'

describe 'TransactionSorter' do

  describe 'setting the sort options' do
    it "is correct if sorting option is in the list" do
      transaction_sorter = TransactionSorter.new("category")
      expect(transaction_sorter.sorting).to eq(:category)
    end

    it "is set the sorting correctly if sorting options is not in the list" do
      transaction_sorter = TransactionSorter.new("foobar")
      expect(transaction_sorter.sorting).not_to eq(:foobar)
    end

    it "is set the sorting correctly if sorting options is nil" do
      transaction_sorter = TransactionSorter.new(nil)
      expect(transaction_sorter.sorting).not_to eq(:foobar)
    end
  end

  describe 'sorting the transactions' do
    before :each do
      @category1 = FactoryGirl.create(:category, :name => "1. Stelle")
      @category2 = FactoryGirl.create(:category, :name => "2. Stelle")

      @user1 = FactoryGirl.create(:user, :name => "A")
      @user2 = FactoryGirl.create(:user, :name => "B")

      @first = FactoryGirl.create(:transaction, :date => 2.days.ago, :category => @category2, :user => @user1)
      @second = FactoryGirl.create(:transaction, :date => 3.days.ago, :category => @category1, :user => @user2)
      @third = FactoryGirl.create(:transaction, :date => 1.day.ago, :category => @category2, :user => @user2)
    end

    it 'sorts the transactions by category' do
      transaction_sorter = TransactionSorter.new(:category)
      expect(transaction_sorter.sort(Transaction)).to eq [@second,@third,@first]
    end

    it 'sorts the transactions by user' do
      transaction_sorter = TransactionSorter.new(:user)
      expect(transaction_sorter.sort(Transaction)).to eq [@first, @third, @second]
    end

    it 'sorts the transactions by date' do
      transaction_sorter = TransactionSorter.new(:date)
      expect(transaction_sorter.sort(Transaction)).to eq [@third, @first, @second]
    end
  end

end