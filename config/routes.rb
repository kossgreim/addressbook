Rails.application.routes.draw do
  # API v1 routes
  scope module: 'api' do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
    end
  end
end
