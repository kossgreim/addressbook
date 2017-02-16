module Api::V1::Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController

    private

    def sign_up_params
      params.permit(
          :first_name, :last_name, :email, :password, :password_confirmation, :organization_id
      )
    end

    def account_update_params
      params.permit(
          first_name, :last_name, :email, :password, :password_confirmation, :organization_id
      )
    end
  end
end