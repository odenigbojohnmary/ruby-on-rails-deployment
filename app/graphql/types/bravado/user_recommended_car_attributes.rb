# frozen_string_literal: true

module Types
  module Bravado
    class UserRecommendedCarAttributes < Types::BaseInputObject
      description 'Attributes for a user recommended cars'

      argument :user_id, ID, 'User ID'
      argument :query, String, 'Car brand name or part of car brand name to filter by', required: false
      argument :price_min, Float, 'Minimum price', required: false
      argument :price_max, Float, 'Maximum price', required: false
      argument :page, Integer, 'Page number for pagination', required: false, default_value: 1
    end
  end
end
