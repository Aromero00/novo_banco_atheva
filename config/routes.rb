Rails.application.routes.draw do
        resources :transactions
        Rails.application.routes.draw do
          resources :regions do
            get 'total_users', on: :member
            get 'total_agencies', on: :member
          end

          resources :agencies do
            resources :users, only: [:index], controller: 'users', action: 'index_by_agency'
          end

          resources :users do
            resources :transactions, only: [:index], controller: 'transactions', action: 'index_by_user'
          end

          resources :transactions, only: [:create, :destroy]
        end
end
