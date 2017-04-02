Rails.application.routes.draw do
  resources :channels, only: [:index, :show] do
    resources :items, only: [:index, :show]
  end
end
