# frozen_string_literal: true

class UpdateUserPreferredCarsService
  include Dry::Monads[:result]

  def initialize(user_id)
    @user_id = user_id
  end

  def call
    result = External::FetchUserPreferredCarsService.new(@user_id).call

    if result.success?
      Success(create_or_update_preferred_cars(result.value!))
    else
      Failure(result.failure)
    end
  end

  private

  def create_or_update_preferred_cars(preferred_cars)
    attributes = preferred_cars.map { |r| r.merge({ user_id: @user_id }) }

    UserPreferredCar.upsert_all(attributes)
  end
end
