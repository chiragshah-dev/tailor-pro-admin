class OrderMeasurement < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :order_item, optional: true
  belongs_to :order, optional: true
  belongs_to :measurement_field

  enum :unit, { cm: "cm", inches: "inches" }
end
