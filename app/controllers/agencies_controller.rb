class AgenciesController < ApplicationController
  before_action :set_agency, only: %i[ show update destroy ]

  # GET /agencies
  def index
    @agencies = Agency.joins(:region)
                      .left_joins(:users)
                      .select('agencies.*, regions.name AS region_name, COUNT(users.id) AS total_users')
                      .group('agencies.id, regions.name')

    render json: @agencies
  end

  # GET /agencies/1
  def show
    render json: @agency, methods: [ :region_name, :total_users]
  end



  # POST /agencies
  def create
    @agency = Agency.new(agency_params)

    if @agency.save
      render json: @agency, status: :created, location: @agency
    else
      render json: @agency.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agencies/1
  def update
    if @agency.update(agency_params)
      render json: @agency
    else
      render json: @agency.errors, status: :unprocessable_entity
    end
  end

  # DELETE /agencies/1
  def destroy
    @agency.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agency
      @agency = Agency.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agency_params
      params.require(:agency).permit(:name, :region_id)
    end
end
