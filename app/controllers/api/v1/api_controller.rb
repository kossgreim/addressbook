module Api::V1
  class ApiController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

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
  end
end