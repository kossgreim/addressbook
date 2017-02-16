module Api::V1
  class OrganizationsController < ApiController

    before_action :set_organization, only: [:show, :update, :destroy]
    include PaginationParams

    def index
      organizations = Organization.paginate(pagination_params)

      render json: organizations
    end

    def show
      organization = Organization.find(params[:id])

      render json: organization
    end

    def create
      organization = Organization.new(organization_params)

      if organization.save
        render json: organization, status: :created
      else
        render_error(organization, :unprocessable_entity)
      end
    end

    def update
      if @organization.update_attributes(organization_params)
        render json: @organization, status: :ok
      else
        render_error(@organization, :unprocessable_entity)
      end
    end

    def destroy
      @organization.destroy
      head 204
    end

    private

    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    end
  end
end