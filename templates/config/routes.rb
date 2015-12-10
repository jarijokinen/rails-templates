Rails.application.routes.draw do
  devise_for :users, only: %w()
  as :user do
    get I18n.t('routes.login') => 'devise/sessions#new', as: :new_user_session
    post I18n.t('routes.login') => 'devise/sessions#create', as: :user_session
    delete I18n.t('routes.logout') => 'devise/sessions#destroy', as: :destroy_user_session
    get I18n.t('routes.new_account') => 'devise/registrations#new', as: :new_user_registration
    post I18n.t('routes.new_account') => 'devise/registrations#create', as: :user_registration
    get I18n.t('routes.my_account') => 'devise/registrations#edit', as: :edit_user_registration
    put I18n.t('routes.my_account') => 'devise/registrations#update'

    get "#{I18n.t('routes.confirmation')}/:confirmation_token" => 'devise/confirmations#show', as: :user_confirmation
    
    get I18n.t('routes.change_password') => 'devise/passwords#new', as: :new_user_password
    put I18n.t('routes.change_password') => 'devise/passwords#update', as: :user_password
    post I18n.t('routes.change_password') => 'devise/passwords#create'
    get "#{I18n.t('routes.change_password')}/:reset_password_token" => 'devise/passwords#edit', as: :edit_user_password
  end

  root to: 'public#index'
end
