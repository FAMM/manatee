class CategoriesController < ApplicationController

  before_filter :authenticate_user!
  before_action :set_budget
  before_action :set_category, only: [:destroy, :update]


  # GET /transactions
  # GET /transactions.json
  def index
    @categories = @budget.categories
  end



  def create
    @category = @budget.categories.new(category_params)

    respond_to do |format|
      if @category.save
        budget_categories_url(@budget)

        format.html { redirect_to budget_categories_url(@budget), notice: 'Category was successfully created.' }
        format.json { render :json => @category, status: :created, location: @category }
      else
        format.html { render action: 'index', alert: "Could not create Category: #{@category.errors.full_messags.join("and")}" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.json { render :json => @category }
      else
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if current_user.in?(@category.budget.users) || current_user.admin?
      @category.destroy
      respond_to do |format|
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.json { render :json => t("errors.messages.not_allowed"), :status => :forbidden }
      end
    end
  end

  private
  def set_budget
    @budget = current_user.budgets.find(params[:budget_id])
  end

  def set_category
    @category = @budget.categories.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def category_params
    params.require(:category).permit(:name, :planned)
  end
end
