class AccessoryCategory < ApplicationRecord
  has_many :accessories
  validates :name, presence: true, uniqueness: true
end
