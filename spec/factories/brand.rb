# frozen_string_literal: true

FactoryBot.define do
  factory :brand do
    name { Faker::Team.unique.name }
  end
end
