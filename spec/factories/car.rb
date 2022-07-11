# frozen_string_literal: true

FactoryBot.define do
  factory :car do
    model { Faker::Games::Pokemon.unique.name }
    price { rand(10_000..100_000) }

    brand
  end
end
