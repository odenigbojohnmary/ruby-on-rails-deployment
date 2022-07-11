# frozen_string_literal: true

class UserPreferredCar < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :user_id, presence: true
  validates :car_id, presence: true
  validates :rank_score, presence: true
end
