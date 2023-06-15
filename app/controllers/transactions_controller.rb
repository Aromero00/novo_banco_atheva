class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show update destroy ]

  # GET /transactions
  # GET /transactions
  def index
    @transactions = Transaction.joins(:user)
                               .select('transactions.*, users.name AS user_name')

    render json: @transactions
  end


  def index_by_user
    @user = User.find(params[:user_id])
    @transactions = @user.transactions.joins(:user)
                                      .select('transactions.*, users.name AS user_name')

    render json: @transactions
  end

  # GET /transactions/1
  def show
    render json: @transaction
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)
    user = User.find(transaction_params[:user_id])

    if user.status == 'deletado'
      render json: { error: 'Usuário marcado como deletado. Não é possível fazer transações.' }, status: :unprocessable_entity
    elsif @transaction.save
      update_user_balance(@transaction) # Atualiza o saldo do usuário
      render json: @transaction, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction = Transaction.find(params[:id])
    revert_transaction(@transaction) # Reverte a transação

    @transaction.destroy
  end

  private
  def revert_transaction(transaction)
    user = transaction.user
    reversed_transaction = Transaction.new(
      user: user,
      value: -transaction.value, # valor negativo para reverter a transação
      transaction_type: transaction.transaction_type,
      event: "#{transaction.event} (reversed)" # evento reverso
    )
    reversed_transaction.save

    update_user_balance(reversed_transaction) # atualiza o saldo do usuário
  end

  def update_user_balance(transaction)
    user = transaction.user
    if transaction.transaction_type == 'debit' # Se for uma transação de débito (valor negativo)
      user.balance -= transaction.value
    elsif transaction.transaction_type == 'credit' # Se for uma transação de crédito (valor positivo)
      user.balance += transaction.value
    end
    user.save
  end

  # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end


    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:user_id, :value, :transaction_type, :event)
    end
end
