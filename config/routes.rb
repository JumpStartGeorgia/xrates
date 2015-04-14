BootstrapStarter::Application.routes.draw do
	#--------------------------------
	# all resources should be within the scope block below
	#--------------------------------
	scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

		match '/admin', :to => 'admin#index', :as => :admin, :via => :get
		devise_for :users, :path_names => {:sign_in => 'login', :sign_out => 'logout'},
											 :controllers => {:omniauth_callbacks => "omniauth_callbacks"}

		namespace :admin do
         resources :pages
			resources :users
		end

    # scope "api"  do
    #   resources :rates 
    # end


      match "nbg" => "api/v1#nbg", as: 'nbg', :via => :get
      match "rates" => "api/v1#rates", as: 'rates', :via => :get
      match "calculator" => "api/v1#calculator", as: 'calculator', :via => :get

      match "api" => "root#api", as: 'api', :via => :get
      match "about" => "root#about", as: 'about', :via => :get

		root :to => 'root#index'
	  match "*path", :to => redirect("/#{I18n.default_locale}") # handles /en/fake/path/whatever
	end

	match '', :to => redirect("/#{I18n.default_locale}") # handles /
	match '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
