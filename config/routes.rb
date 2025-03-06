Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do

      post "users/signup" => "users#signup"
      post "users/login" => "users#login"

      
    end
  end
end
