class Service < ApplicationRecord
  has_many :store_service_expertises
  has_many :stores, through: :store_service_expertises
end
