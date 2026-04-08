class Question < ApplicationRecord
  validates :question, presence: true
  validates :answer,   presence: true
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

end
