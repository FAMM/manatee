class UsersController < ApplicationController
  def by_identifier
    identifier = params[:identifier]
    @user = User.find_by_name_or_email(identifier).first
    respond_to do |format|
      format.json {render :json => @user}
    end
  end
end

