# frozen_string_literal: true

class Brand < ApplicationRecord
  has_many :cars, dependent: :destroy
  has_many :user_preferred_brands, dependent: :destroy
  has_many :preferred_users, through: :user_preferred_brands, source: :user
end
