Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'front/top#index'

  get 'zipcode/:zipcode' => 'zip_code#show'

  #
  namespace module: :front do
    
  end

  #
  namespace :admin do
    get '' => 'dashboard#index'

    namespace :estate do
      resources :lands
      resources :houses
      resources :lots do
        resources :divisions, controller: 'lots/divisions' do
          member do
            post "up"   => "lots/divisions/index_order#up"
            post "down" => "lots/divisions/index_order#down"
          end          
        end
      end

      resources :commons do
        resources :blocks do
          member do
            post "up"   => "images/index_order#up"
            post "down" => "images/index_order#down"
          end          
        end
        resources :images do
          member do
            post "up"   => "images/index_order#up"
            post "down" => "images/index_order#down"
          end          
        end
        resources :facilities do
          member do
            post "up"   => "facilities/index_order#up"
            post "down" => "facilities/index_order#down"
          end          
        end
      end
    end

  end
  
end
