Manatee::Application.routes.draw do
  resources :filters

  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
 
  # for the filters
  resource :summary, only: [:show, :create]

  resources :filters, only: [:index, :create, :update, :destroy]

  resources :budgets do
    resources :transactions
    resources :categories
  end

  get 'users/by_identifier/:identifier', :to => 'users#by_identifier'

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end
