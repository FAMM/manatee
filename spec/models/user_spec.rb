require 'spec_helper'

describe 'User' do
  describe 'find by name or email' do
    before :each do
      @user = FactoryGirl.create(:user)
    end

    it 'returns the correct user if email is given' do
      expect(User.find_by_name_or_email(@user.email).first).to eq @user
    end

    it 'returns the correct user if name is given' do
      expect(User.find_by_name_or_email(@user.name).first).to eq @user
    end

    it 'returns nil if no user with this email exists' do
      expect(User.find_by_name_or_email("test_"+@user.email).first).to be nil
    end

    it 'returns nil if no user with this name exists' do
      expect(User.find_by_name_or_email("test_"+@user.name).first).to be nil
    end
  end

  describe 'creating a budget if user is created' do
    it 'creates a budget if the user is created' do
      user = FactoryGirl.create(:user)
      expect(user.budgets.count).to eql 1
    end
  end

end
