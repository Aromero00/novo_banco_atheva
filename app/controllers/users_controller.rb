class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    if params[:agency_id]
      @users = User.joins(:region, :agency)
                   .left_joins(:transactions)
                   .where(agency_id: params[:agency_id])
                   .select('users.*, regions.name AS region_name, agencies.name AS agency_name,
                          COUNT(transactions.id) AS total_transactions')
                   .where('transactions.created_at >= ?', 30.days.ago)
                   .group('users.id, regions.name, agencies.name')
    else
      @users = User.joins(:region, :agency)
                   .left_joins(:transactions)
                   .select('users.*, regions.name AS region_name, agencies.name AS agency_name,
                          COUNT(transactions.id) AS total_transactions')
                   .where('transactions.created_at >= ?', 30.days.ago)
                   .group('users.id, regions.name, agencies.name')
    end

    render json: @users
  end
  def index_by_agency
    @agency = Agency.find(params[:agency_id])
    @users = @agency.users.joins(:region, :agency)
                    .select('users.*, regions.name AS region_name, agencies.name AS agency_name')


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
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :cpf, :region_id, :agency_id, :balance, :status)
    end
end
