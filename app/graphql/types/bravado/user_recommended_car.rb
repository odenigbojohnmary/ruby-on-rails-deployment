# frozen_string_literal: true

module Types
  module Bravado
    class UserRecommendedCar < Types::BaseObject
      description 'User recommended car'

      field :id, ID, 'ID', null: false
      field :brand, Brand, 'Brand', null: false
      field :price, Float, 'Price', null: false
      field :rank_score, Float, 'Value from AI service'
      field :model, String, 'Model name', null: false
      field :label, String, 'perfect_match | good_match | null', null: false

      def label
        {
          0 => 'null',
          1 => 'good_match',
          2 => 'perfect_match'
        }[object.label]
      end
    end
  end
end
