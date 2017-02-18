module Api::V1
  class OrganizationsController < ApiController
    include PaginationParams
    include JsonApiParams

    before_action :authenticate_user!, except: [:index]
    before_action :set_organization, only: [:show, :update, :destroy]

    def index
      organizations = Organization.paginate(pagination_params)

      render json: organizations
    end

    def show
      authorize @organization

      render json: @organization
    end

    def create
      organization = Organization.new(organization_params)
      authorize organization

      if organization.save
        render json: organization, status: :created
      else
        render_error(organization, :unprocessable_entity)
      end
    end

    def update
      authorize @organization
      if @organization.update_attributes(organization_params)
        render json: @organization, status: :ok
      else
        render_error(@organization, :unprocessable_entity)
      end
    end

    def destroy
      authorize @organization
      @organization.destroy
      head 204
    end

    private

    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      permit_params([:name])
    end

    def check_authorization
      authorize current_user if current_user
    end
  end
end