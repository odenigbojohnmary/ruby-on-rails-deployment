class CreateCarRecommendations < ActiveRecord::Migration[6.1]
  def change
    create_table :car_recommendations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true

      t.decimal :rank_score, null: false

      t.timestamps default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
