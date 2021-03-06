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

    # For authenticating with LinkedIn
    scope :linkedin do
      get 'auth' => 'linkedin#auth', as: 'linkedin_auth'
      get 'callback' => 'linkedin#callback', as: 'linkedin_callback'
    end

    # The admin section for a company
    namespace 'admin' do

      # The company itself
      get '/', to: 'companies#show'
      delete '/', to: 'companies#delete'

      # Settings
      scope 'settings' do

        # Company
        get '', to: redirect('/admin/settings/company')
        get 'company', to: 'companies#edit'
        patch 'company', to: 'companies#update'

        # User
        get 'profile', to: 'users#edit'
        patch 'profile', to: 'users#update'

        # Team
        get 'team', to: 'companies#team'

        # Subscriptions
        get 'subscription', to: 'companies#subscription'
        patch 'subscription/billing', to: 'companies#manage_subscription'
        patch 'subscription/plan', to: 'companies#update_plan'
        patch 'subscription/cancel', to: 'companies#cancel_subscription'

        # Email Notifications
        get 'notifications', to: 'companies#notifications'
        patch 'notifications', to: 'companies#update_notifications'

      end

      resources :company_administrators, only: [:create, :destroy]

      # Jobs
      resources :jobs, except: [:index] do
        resources :applications, only: [:show] do
          member do
            patch 'reject'
            patch 'review'
            patch 'interview'
            patch 'hire'
          end
          resources :notes, only: [:create, :delete]
        end
      end

      # Attachments
      # resources :attachments, only: [:show, :delete]

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

  # -------------------------------------------------------------------------------------------------------------------
  # Temp Files
  # -------------------------------------------------------------------------------------------------------------------
  resources :temp_logos, only: [:create]
  resources :temp_files, only: [:create]

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
