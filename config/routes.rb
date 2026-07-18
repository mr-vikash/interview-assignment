Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :ebooks do
        member do
          get :download
        end

        collection do
          get :search
        end
      end
    end
  end
end