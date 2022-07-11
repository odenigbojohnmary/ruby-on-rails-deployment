# frozen_string_literal: true

module External
  class FetchUserPreferredCarsService
    include Dry::Monads[:result]

    BASE_URI = 'https://bravado-images-production.s3.amazonaws.com/'

    def initialize(user_id)
      @user_id = user_id
    end

    def call
      connection = Faraday.new(
        url: BASE_URI,
        params: { user_id: @user_id },
        headers: { 'Content-Type' => 'application/json' }
      )

      response = connection.get('/recomended_cars.json')

      if response.success?
        preferred_cars = JSON.parse(response.body).map(&:with_indifferent_access)
        Success(preferred_cars)
      else
        Failure([response.status, response.body])
      end
    end
  end
end
