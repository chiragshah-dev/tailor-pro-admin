class StitchIt::Product < ApplicationRecord
  belongs_to :category,
             class_name: "StitchIt::Category"
  validates :name, presence: true
end
