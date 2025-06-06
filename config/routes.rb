Rails.application.routes.draw do
  resources :editors, only: [:new, :create]
  root 'editors#new'
end
