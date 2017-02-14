Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]

  # API v1 routes
  constraints subdomain: 'api' do
    scope module: 'api' do
      namespace :v1 do

      end
    end
  end
end
