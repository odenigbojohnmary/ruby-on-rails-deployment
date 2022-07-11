# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    preferred_price_range { rand(10_000..50_000)...rand(50_000...100_000) }
  end
end
