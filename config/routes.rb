Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    namespace :v1 do

      post "users/signup" => "users#signup"
      post "users/login" => "users#login"

      
    end
  end
end
