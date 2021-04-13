Rails.application.routes.draw do
  root to: 'contacts#index'
  devise_for :users
  resources :contacts, only: [:index, :destroy]
  resources :contact_files, except: [:edit, :update, :show]
  resources :failed_contacts, only: [:index, :show]
  post '/contact_file/import/:id', to: 'contact_files#import'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
