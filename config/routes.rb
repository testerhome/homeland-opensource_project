Homeland::OpensourceProject::Engine.routes.draw do
  resources :opensource_projects do
    collection do
      post :preview
    end
    member do
      put :publish
    end
  end
  namespace :admin do
    resources :opensource_projects do
      collection do
        get :upcoming
      end

      member do
        post :undestroy
      end
    end
  end
end
