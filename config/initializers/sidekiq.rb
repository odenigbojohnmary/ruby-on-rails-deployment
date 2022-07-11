# frozen_string_literal: true

require 'sidekiq/web'

module Sidekiq
  RetryError = Class.new(StandardError)
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/1') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/1') }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(user), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USER'])) &
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password),
                               ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
end
