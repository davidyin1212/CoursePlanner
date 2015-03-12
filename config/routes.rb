Rails.application.routes.draw do

  get 'session/index'

  devise_for :users, controllers: { registrations: "registrations" }
  # get 'log_in' => 'sessions#new', :as => 'log_in'
  # get 'log_out' => 'sessions#destroy', :as => 'log_out' 
  
  # get 'sessions/create'

  # get 'sessions/destroy'

  get 'landing/index'

  # get 'sign_up' => "users#new", :as => 'sign_up'

  resources :degrees do
    member do
      get 'addCoursePage'
      get 'addCourse'
      get 'edit_page'

      get 'addReq'
    end
  end

  resources :courses do
	resources :comments
	end
	
  resources :users do
    member do
      get 'addDegreePage'
      get 'addDegree'
      get 'addCoursePage'
      get 'addCourse'

      get 'remDegree'
      get 'remCourse'

    end
  end
  # resources :sessions

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'session#index'

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
