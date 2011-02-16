ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # For wysihat editor uploads
  map.resources :wysihat_files
  
  # root
  map.root :controller => "site", :action => "spawn"
  
  # Public articles feed
  map.resources :feeds, :only => [:index]
  
  #session routes
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.forgot '/forgot', :controller => 'users', :action => 'forgot'  
  map.reset 'reset/:reset_code', :controller => 'users', :action => 'reset'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.resources :users
  map.resource :session
  
  #Admin routes
  map.admin 'admin', :controller => 'admin/pages'
  map.admin_login 'admin/login', :controller => 'admin/admin', :action => 'login'
  
  map.namespace :admin do |admin|
    admin.resources :pages, :collection => {:update_positions => :post, :editing_language => :post}, :member => {:toggle => :post, :apply_template => :post} do |page|
      page.resources :snippets, :collection => {:sort => :post}, :member => {:toggle => :post}
    end
    admin.resource :settings do |setting|
      setting.resources :templates do |template|
        template.resources :snippets, :collection => {:sort => :post}, :member => {:toggle => :post}
      end
      setting.resources :layouts
    end
    admin.resources :users
    admin.resources :articles, :member => {:toggle => :post}
    admin.resources :assets
    admin.resources :categories
    admin.resources :tags
  end
  
  #Public routes
  #map.resources :articles, :collection => {:carousel => :get}, :only => [:index, :carousel] #to be deleted if not used!!
  map.resources :articles, :collection => {:carousel => :get}, :only => [:carousel]
  map.resources :comments, :only => [:create, :destroy]
  map.show_article ':lang/article/:year/:month/:day/:pretty_url', :controller => 'articles', :action => 'show', :requirements => {:lang => /en|it|gr/, :year => /\d+/, :month => /\d+/, :day => /\d+/}
  map.connect ':lang/*page_url', :controller => 'site', :action => "spawn", :requirements => {:lang => /en|it|gr/}
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)