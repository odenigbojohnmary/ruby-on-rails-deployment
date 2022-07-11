# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateUserPreferredCarsService do
  include Dry::Monads[:result]

  describe '#call' do
    it 'creates user preferred cars' do
      user = create(:user)
      car1 = create(:car)
      car2 = create(:car)

      recommendation_service_data = [
        { car_id: car1.id, rank_score: 0.95 },
        { car_id: car2.id, rank_score: 0.33 }
      ]
      recommendation_service_object = instance_double(External::FetchUserPreferredCarsService)

      allow(External::FetchUserPreferredCarsService).to receive(:new).and_return(recommendation_service_object)
      allow(recommendation_service_object).to receive(:call).and_return(Success(recommendation_service_data))

      expect do
        described_class.new(user.id).call
      end.to change(UserPreferredCar, :count).from(0).to(2)
    end
  end
end
