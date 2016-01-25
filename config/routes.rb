Rails.application.routes.draw do
  get 'uploads/new'

  get 'uploads/create'

  get 'uploads/index'

  resources :uploads
end
