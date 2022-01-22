Rails.application.routes.draw do
    devise_for :users,
               defaults: { format: :json },
               path: '',
               path_names: {
                 sign_in: 'login',
                 sign_out: 'logout'
               },
               controllers: {
                 sessions: 'sessions'
               }
    get '/current_user', to: 'ner_models#index'
    get '/list_models', to: 'ner_models#models'
    get '/list_tasks/:transkribus_user_id', to: 'ner_models#tasks'
    post '/train', to: 'ner_models#train'
    post '/recognize', to: 'ner_models#recognize'
    get '/status/:task_id', to: 'ner_models#task_status'
end
