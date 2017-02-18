module Api::V1
  class ContactsController < ApiController
    include JsonApiParams

    before_action :authenticate_user!
    before_action :set_service
    before_action :set_contact, except: [:index, :create]

    def index
      contacts = @service.find_by_organization(params[:organization_id])

      render json: contacts
    end

    def show
      render json: @contact
    end

    def create
      contact = Contact.new(contact_params)
      if contact.validate
        contact = @service.create(contact, params[:organization_id])
        head :bad_gateway unless contact

        render json: contact, status: :created
      else
        render_error(contact, :unprocessable_entity)
      end
    end

    def update
      @contact.attributes = contact_params
      if @contact.validate
        result = @service.update(@contact, params[:organization_id], params[:id])
        head :bad_gateway unless result

        render json: result, status: :ok
      else
        render_error(@contact, :unprocessable_entity)
      end
    end

    def destroy
      result = @service.destroy(params[:organization_id], params[:id])
      if result
        head :no_content
      else
        head :bad_gateway
      end
    end

    private

    def contact_params
      params = permit_params([:first_name, :last_name, :email, :phone, :organization_id])
      params.merge({author_id: current_user.id})
    end

    def set_service
      @service = ContactService.new
    end

    def set_contact
      @contact = @service.find(params[:organization_id], params[:id])
    end
  end
end