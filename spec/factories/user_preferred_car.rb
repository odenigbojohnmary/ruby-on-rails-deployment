# frozen_string_literal: true

FactoryBot.define do
  factory :user_preferred_car do
    user { association :user }
    car { association :car }
  end
end
