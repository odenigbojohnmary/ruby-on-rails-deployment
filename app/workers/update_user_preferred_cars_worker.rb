# frozen_string_literal: true

class UpdateUserPreferredCarsWorker
  include Sidekiq::Job

  def perform(user_id)
    result = UpdateUserPreferredCarsService.new(user_id).call

    raise Sidekiq::RetryError, result.failure if result.failure?

    true
  end
end
