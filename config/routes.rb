Rails.application.routes.draw do

  root to: 'static_pages#home'

  # -------------------------------------------------------------------------------------------------------------------
  # Users
  # -------------------------------------------------------------------------------------------------------------------
  devise_for :users
  devise_scope :user do
    get 'register', to: "devise/registrations#new"
    get 'login', to: "devise/sessions#new"
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Companies
  # -------------------------------------------------------------------------------------------------------------------
  resources :companies, except: [:index] do
    resources :company_administrators, only: [:create]
    resources :jobs, only: [:new, :create, :index]
  end
  resources :jobs, only: [:show, :edit, :update, :delete]


  # -------------------------------------------------------------------------------------------------------------------
  # Subdomains
  # -------------------------------------------------------------------------------------------------------------------

  # Attempts at subdomain routing, first lets match www. to the home page to avoid mishaps
  match '/', to: 'static_pages#home', constraints: { subdomain: 'www' }, via: [:get, :post, :put, :patch, :delete]
  # now lets use a regex to point any subdomains to their relevant companies
  match '/', to: 'companies#show', constraints: { subdomain: /.+/ }, via: [:get, :post, :put, :patch, :delete]

  # --------------------------------------------------------------------------------
  # Static Pages
  # --------------------------------------------------------------------------------
  get 'home' => 'static_pages#home', as: :home
  get 'about' => 'static_pages#about', as: :about
  get 'dashboard' => 'static_pages#dashboard', as: :dashboard


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
