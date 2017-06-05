Rails.application.routes.draw do
  resources :channels, only: [:index, :show] do
    resources :items, only: [:index, :show]
  end

  resources :playlists do
    resources :playlist_elements, except: :show
  end

  resources :subscriptions, except: :show
end
