class Api::V1::CompaniesController < ApiController 
  before_action :set_company, only: [:show]

  def index 
    # @companies = Company.all
    @companies = current_user.companies
  end

  def show 
    render json: @company, status: :ok
  end

  def create 
    # @company = Company.new(company_params)
    @company = current_user.companies.new(company_params)
    if @company.save 
      render json: @company, status: :ok
    else  
      render json: {
        data: @company.error.full_messages, status: "failed"
      }, status: :unprocessable_entity
    end
  end

  private 
    def set_company
      # @company = Company.find(params[:id]);
      @company = current_user.companies.find(params[:id])
    rescue ActiveRecord::RecordNotFound => error 
      render json: error.message, status: :unauthrozid
    end

    def company_params 
      params.require(:company).permit(:name, :address, :established_year, :user_id)
    end
end