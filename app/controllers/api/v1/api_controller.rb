module Api::V1
  class ApiController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
    include Pundit
    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
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

    # handles not pundit's not authorized exception
    def user_not_authorized
      render json: {errors: ["You're not authorized to perform this action"]},
             status: :forbidden,
             adapter: :json_api
    end
  end
end