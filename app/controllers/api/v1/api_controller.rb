module Api::V1
  class ApiController < ApplicationController

    include DeviseTokenAuth::Concerns::SetUserByToken
    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
    #before_action :check_content_type

    private

    def record_not_found(error)
      render json: { errors: error.message }, status: :not_found
    end

    def render_error(resource, status)
      render json: resource,
        status: status,
        adapter: :json_api,
        serializer: ActiveModel::Serializer::ErrorSerializer
    end

    # checks for correct content-type according to json api spec
    def check_content_type
      if %w(POST PUT PATCH).include? request.method
        head 406 unless request.content_type == 'application/vnd.api+json'
      end
    end
  end
end