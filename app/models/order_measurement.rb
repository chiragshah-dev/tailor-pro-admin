class OrderMeasurement < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :order_item, optional: true
  belongs_to :order, optional: true
  belongs_to :measurement_field, optional: true
  belongs_to :store_measurement_field, optional: true

  enum :unit, { cm: "cm", inches: "inches" }
end
