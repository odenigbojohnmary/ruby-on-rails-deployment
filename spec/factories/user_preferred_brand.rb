# frozen_string_literal: true

FactoryBot.define do
  factory :user_preferred_brand do
    user { association :user }
    brand { association :brand }
  end
end
