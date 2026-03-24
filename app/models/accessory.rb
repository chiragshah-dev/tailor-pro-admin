class Accessory < ApplicationRecord
  belongs_to :accessory_category
  validates :name, presence: true
end
