Rails.application.routes.draw do
  if Rails.env.development?
    require 'sidekiq/web'
    Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
    mount Sidekiq::Web => '/sidekiq'
  end
  root 'pages#home'
end
