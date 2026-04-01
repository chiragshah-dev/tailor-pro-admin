class StitchIt::Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :products,
           class_name: "StitchIt::Product",
           foreign_key: :category_id,
           dependent: :restrict_with_error

  # Self reference
  belongs_to :parent,
             class_name: "StitchIt::Category",
             optional: true

  has_many :children,
           class_name: "StitchIt::Category",
           foreign_key: :parent_id,
           dependent: :restrict_with_error
end
