Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :registrations, :passwords]
  # API v1 routes
  scope module: 'api' do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks], controllers: {
          registrations:  'api/v1/overrides/registrations'
      }
      resources :organizations do
        resources :contacts
      end
    end
  end
end