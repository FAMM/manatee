class TransactionsController < ApplicationController

  before_filter :authenticate_user!
  before_action :set_budget
  before_action :set_transaction, only: [:edit, :update, :destroy]

  # GET /transactions
  # GET /transactions.json
  def index
    transaction_finder = TransactionFinder.new(@budget,params[:categories],params[:sort])
    @transactions = transaction_finder.transactions
  end

  # GET /transactions/new
  def new
    @transaction = current_user.transactions.new
    @transaction.budget = @budget
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = current_user.transactions.new(transaction_params)
    @transaction.budget=@budget

    respond_to do |format|
      if @transaction.save
        redirect_path = params[:continue] ? new_budget_transaction_url(@budget) : budget_transactions_url(@budget)

        format.html { redirect_to redirect_path, notice: 'Transaction was successfully created.' }
        format.json { render :json => @transaction, status: :created, location: @transaction }
      else
        format.html { render action: 'new' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to budget_transactions_url(@budget), notice: 'Transaction was successfully updated.' }
        format.json { render :json => @transaction }
      else
        format.html { render action: 'edit' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    if current_user == @transaction.user || current_user.admin?
      @transaction.destroy
      respond_to do |format|
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @transaction, :alert => t("errors.messages.not_allowed") }
        format.json { render :json => t("errors.messages.not_allowed"), :status => :forbidden }
      end
    end
  end

  private
    def set_budget
      @budget = current_user.budgets.find(params[:budget_id])
    end

    def set_transaction
      @transaction = @budget.transactions.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:amount, :comment, :category_id, :budget_id, :date )
    end
end
