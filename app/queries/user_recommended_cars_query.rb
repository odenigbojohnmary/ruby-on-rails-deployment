# frozen_string_literal: true

class UserRecommendedCarsQuery
  def initialize(params)
    @params = params
  end

  def call
    query = Car
            .joins(joins_cond)
            .includes(:brand)
            .select("cars.*, user_preferred_cars.rank_score, #{label_cond}")

    query = query.where('brands.name LIKE ?', "%#{@params[:query]}%") if @params[:query].present?
    query = query.where('price >= ?', @params[:price_min]) if @params[:price_min].present?
    query = query.where('price <= ?', @params[:price_max]) if @params[:price_max].present?
    query.order('label DESC, rank_score DESC NULLS LAST, price ASC')
  end

  private

  def joins_cond
    <<~JOINS.strip
      JOIN brands ON cars.brand_id = brands.id
      LEFT JOIN user_preferred_brands ON brands.id = user_preferred_brands.brand_id
      LEFT JOIN user_preferred_cars ON cars.id = user_preferred_cars.car_id
      LEFT JOIN users ON users.id IN (user_preferred_brands.user_id, user_preferred_cars.user_id) AND users.id = #{ActiveRecord::Base.connection.quote(@params[:user_id])}
    JOINS
  end

  def label_cond
    <<~LABEL.strip
      CASE
        WHEN user_preferred_brands.id IS NOT NULL
        THEN
          CASE
            WHEN users.preferred_price_range::int8range @> cars.price::bigint THEN 2
            ELSE 1
          END
        ELSE 0
      END AS label
    LABEL
  end
end
