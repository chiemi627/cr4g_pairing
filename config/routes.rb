Rails.application.routes.draw do
  get 'events/new'
  post 'events/create'

  root 'pairings#pair'

  get 'pairings/save'
  get 'pairings/show/:id', to: 'pairings#show'
  get 'wit19', to: 'pairings#index'
  get ':id', to:'pairings#show'

  get 'events/:account', to: 'pairings#index'

  get 'pairings/pair'
  post 'pairings/pair'
  get 'pairings/index'
  post 'pairings/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
