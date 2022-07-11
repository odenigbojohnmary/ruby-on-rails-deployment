# frozen_string_literal: true

class UpdateUsersPreferredCarsWorker
  include Sidekiq::Job

  def perform
    User.ids.each do |user_id|
      UpdateUserPreferredCarsWorker.perform_async(user_id)
    end

    true
  end
end
