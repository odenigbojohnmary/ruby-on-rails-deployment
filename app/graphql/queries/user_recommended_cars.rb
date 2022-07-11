# frozen_string_literal: true

module Queries
  module UserRecommendedCars
    extend ActiveSupport::Concern

    included do
      field :get_user_recommended_cars, ::Types::Bravado::UserRecommendedCar.connection_type, null: false,
                                                                                              max_page_size: 20 do
        argument :attributes, ::Types::Bravado::UserRecommendedCarAttributes
      end
    end

    def get_user_recommended_cars(attributes:)
      UserRecommendedCarsQuery.new(attributes).call
    end
  end
end
