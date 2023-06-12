Rails.application.routes.draw do
        resources :transactions
        Rails.application.routes.draw do
          resources :regions do
            get 'total_users', on: :member
            get 'total_agencies', on: :member
          end

          resources :agencies do
            get 'total_users', on: :member
          end

          resources :users do
            resources :transactions, only: [:index]
          end

          resources :transactions, only: [:create, :destroy]
        end
end
