# frozen_string_literal: true

module Types
  module Bravado
    class Brand < Types::BaseObject
      description 'Cars\' brands'

      field :id, ID, null: false
      field :name, String, null: false
    end
  end
end
