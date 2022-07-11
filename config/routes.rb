# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'
  mount Sidekiq::Web => '/sidekiq'

  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: 'graphql#execute' if Rails.env.production?
  get '/health_check', to: proc { [200, {}, ['success']] }
end
