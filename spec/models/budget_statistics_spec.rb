require 'spec_helper'

describe 'BudgetStatistics' do

  describe "category_distribution" do
    it "returns the distribution data" do
      budget = FactoryGirl.create(:budget)
      category = FactoryGirl.create(:category, :budget => budget)

      statistics = BudgetStatistics.new(budget)

      expect(statistics.category_distribution).to eq([{:value => category.used_this_month.to_i, :color => category.color}])
    end

  end


end
