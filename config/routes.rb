Rails.application.routes.draw do
  if Rails.env.development?
  end

  post "/graphql", to: "graphql#execute"
  get "/graphql", to: "graphql#execute"

  if Rails.env.development?
    require 'sidekiq/web'
    Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
    mount Sidekiq::Web => '/sidekiq'
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  root 'pages#home'
end
