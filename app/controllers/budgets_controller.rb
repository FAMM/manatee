class BudgetsController < ApplicationController

  before_filter :authenticate_user!
  before_action :set_budget, only: [:edit, :update, :destroy]

  def index
    @budgets = current_user.budgets.includes(:categories).includes(:transactions)
  end

  def show
    @budget = current_user.budgets.includes(:categories).includes(:transactions).find(params[:id])
    @statistics = BudgetStatistics.new(@budget)
  end

  def new
    @budget = current_user.budgets.build
    @budget.users << current_user
  end

  def edit
  end

  def create
    @budget = current_user.budgets.new(budget_params)
    @budget.creator = current_user

    respond_to do |format|
      if @budget.save
        format.html { redirect_to @budget, notice: 'Budget was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @budget.update(budget_params)
        format.html { redirect_to @budget, notice: 'Budget was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /budgets/1
  # DELETE /budgets/1.json
  def destroy
    if @budget.single_user? || !current_user==@budget.creator
      message = budget.single_user? 'You cannot delete your personal budget.':'You are not allowed to remove this budget.'
      respond_to do |format|
        format.html { redirect_to @budget, alert: message}
        format.json { head :not_allowed }
      end
    else
      @budget.destroy
      respond_to do |format|
        format.html { redirect_to budgets_url }
        format.json { head :no_content }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_budget
    @budget = current_user.budgets.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def budget_params
    params.require(:budget).permit(:name, :description, :currency, :user_id_list)
  end
end
