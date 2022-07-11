class RenameCarRecommendationsToUserPreferredCars < ActiveRecord::Migration[6.1]
  def self.up
    rename_table :car_recommendations, :user_preferred_cars
  end

  def self.down
    rename_table :user_preferred_cars, :car_recommendations
  end
end
