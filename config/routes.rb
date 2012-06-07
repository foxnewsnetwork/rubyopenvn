Rubyopenvn::Application.routes.draw do
  # Element / Artwork
  resources :elements, :only => [:create, :destroy, :update]
  # Story stacks
  resources :stories do
    resources :chapters, :except => [:new] do
      resources :scenes, :only => [:create, :update, :destroy, :index]
    end # chapters
  end # stories

  devise_for :users

  #had to include index to get test to work. How odd?
  #Seems like it works for now so leave it.
# While this looks like a rspec / rails bug
# experience says it's my fault
  resources :users
  resources :cats

  #match ':controller/:show/:id/reviews'
  match 'stories/:id/*tab' => 'stories#show'
  match '/stories/:id/:title' => 'stories#show', :as => :story_with_title

# After extensive testing, it seems resource is broken altogether
# It can't be helped, at this rate, we will have to do it the old fashion way
# Once again, is there a hero amongst us who can figure out what's wrong?
#  match "users", :to => "users#index", :as => :users, :via => :get
#  match "users", :to => "users#create", :via => :post
#  match "users/new", :to => "users#new", :as => :new_user, :via => :get
#  match "users/:id/edit", :to => "users#edit", :as => :edit_user, :via => :get
#  match "users/:id", :to => "users#show", :as => :user, :via => :get
#  match "users/:id", :to => "users#update", :via => :put
#  match "users/:id", :to => "users#delete", :via => :delete
#  resource :users
#

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "pages#home"
  match "i", :to => "pages#index"
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
