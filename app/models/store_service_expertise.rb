class StoreServiceExpertise < ApplicationRecord
  belongs_to :store
  belongs_to :service, optional: true
  belongs_to :expertise, optional: true
end
