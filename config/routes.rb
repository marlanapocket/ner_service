Rails.application.routes.draw do
    devise_for :users, controllers: {
      omniauth_callbacks: 'omniauth_callbacks'
    }
    post '/users/auth/developer/callback', to: 'sessions#create'
    resources :ner_models, only: :index
    post '/train', to: 'ner_models#train'
    post '/recognize', to: 'ner_models#recognize'
    get '/status/:task_id', to: 'ner_models#status'
end
