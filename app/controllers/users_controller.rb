class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.joins(:region, :agency)
                 .joins("left join transactions on users.id = transactions.user_id and transactions.created_at >= '#{30.days.ago}'")
                 .select("users.*, regions.name AS region_name, agencies.name AS agency_name,
                        COUNT(transactions.id) AS total_transactions")
                 .group('users.id, regions.name, agencies.name')

    @users = @users.where(agency_id: params[:agency_id]) if params[:agency_id]

    render json: @users
  end

  # GET /users/1
  def show
    render json: @users, methods: [:region_name, :agency_name, :total_transactions]
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    if @user.update(status: 'deletado')
      render json: { message: 'Usuário marcado como deletado' }
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :cpf, :region_id, :agency_id, :status).merge(balance: 0)
  end
end
