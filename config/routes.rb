Rails.application.routes.draw do

  # -------------------------------------------------------------------------------------------------------------------
  # Subdomains
  # http://railscasts.com/episodes/123-subdomains-revised
  # http://railscasts.com/episodes/221-subdomains-in-rails-3
  # -------------------------------------------------------------------------------------------------------------------
  # match '/', to: 'companies#show', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }, via: [:get, :post, :put, :patch, :delete]

  # Company specific routes
  constraints(Subdomain) do

    # The root url for a company
    get "/", to: "companies#show"

    # External Job views
    resources :jobs, only: [:index, :show] do
      member do
        get 'apply', to: 'applications#new'
        post 'apply', to: 'applications#create'
      end
    end

    resources :applications, only: [] do
      member do
        get 'auth'
        get 'auth_callback'
      end
    end

    # The admin section for a company
    namespace 'admin' do

      # The company itself
      get '/', to: 'companies#show'
      get '/edit', to: 'companies#edit'
      put '/', to: 'companies#update'
      patch '/', to: 'companies#update'
      delete '/', to: 'companies#delete'

      # Jobs
      resources :jobs, except: [:index] do
        resources :applications, only: [:show] do
          member do
            patch 'reject'
            patch 'review'
            patch 'interview'
            patch 'hire'
          end
        end
      end

      # Applications
      resources :applications, only: [:show]

    end

  end

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
  resources :companies, only: [:new, :create] do

  end

  # --------------------------------------------------------------------------------
  # Static Pages
  # --------------------------------------------------------------------------------
  get 'home' => 'static_pages#home', as: :home
  get 'about' => 'static_pages#about', as: :about
  # get 'dashboard' => 'static_pages#dashboard', as: :dashboard
  get 'pricing' => 'static_pages#pricing', as: :pricing




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
