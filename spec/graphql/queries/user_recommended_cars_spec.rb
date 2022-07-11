# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::UserRecommendedCars, type: :request do
  describe 'getUserRecommendedCars' do
    it 'returns Types::Bravado::UserRecommendedCar[]' do
      user = create(:user, preferred_price_range: 20_000...40_000)

      brand1 = create(:brand)
      brand2 = create(:brand)
      brand3 = create(:brand)

      create(:user_preferred_brand, user_id: user.id, brand_id: brand1.id)
      create(:user_preferred_brand, user_id: user.id, brand_id: brand2.id)

      car1 = create(:car, brand: brand1, price: 30_000)
      car2 = create(:car, brand: brand2, price: 50_000)
      car3 = create(:car, brand: brand3, price: 90_000)

      pref_car1 = create(:user_preferred_car, user_id: user.id, car_id: car1.id, rank_score: 0.9)
      pref_car2 = create(:user_preferred_car, user_id: user.id, car_id: car2.id, rank_score: 0.8)
      pref_car3 = create(:user_preferred_car, user_id: user.id, car_id: car3.id, rank_score: 0.7)

      query = <<~QUERY
        {
          getUserRecommendedCars(attributes: {userId: #{user.id}}) {
            nodes {
              id
              brand {
                id
                name
              }
              price
              rankScore
              model
              label
            }
          }
        }
      QUERY
      post '/graphql', params: { query: query }

      json = JSON.parse(response.body)
      data = json['data']['getUserRecommendedCars']['nodes']

      expect(data).to eql(
        [
          {
            'id' => car1.id.to_s,
            'brand' => {
              'id' => brand1.id.to_s,
              'name' => brand1.name
            },
            'price' => car1.price.to_f,
            'rankScore' => pref_car1.rank_score.to_f,
            'model' => car1.model,
            'label' => 'perfect_match'
          },
          {
            'id' => car2.id.to_s,
            'brand' => {
              'id' => brand2.id.to_s,
              'name' => brand2.name
            },
            'price' => car2.price.to_f,
            'rankScore' => pref_car2.rank_score.to_f,
            'model' => car2.model,
            'label' => 'good_match'
          },
          {
            'id' => car3.id.to_s,
            'brand' => {
              'id' => brand3.id.to_s,
              'name' => brand3.name
            },
            'price' => car3.price.to_f,
            'rankScore' => pref_car3.rank_score.to_f,
            'model' => car3.model,
            'label' => 'null'
          }
        ]
      )
    end
  end
end
