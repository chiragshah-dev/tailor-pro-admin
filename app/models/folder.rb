class Folder < ApplicationRecord
  enum :gender, { male: 0, female: 1, both: 2 }

  # Associations
  belongs_to :user
  belongs_to :store
  has_many :media, class_name: "Media", dependent: :destroy

  # add self referentail association -->  for nesting folders
  belongs_to :parent, class_name: 'Folder', optional: true # a folder may have a parent folder (but its optional)
  has_many :sub_folders, class_name: 'Folder', foreign_key: 'parent_id', dependent: :destroy # a folder can have many sub-folders

  # Validations
  validates :name, presence: true
  validates :gender, presence: true , if: -> { parent.nil? } # only validate gender if its a root folder

  # Scopes
  scope :for_gender, ->(gender) { where(gender: [gender, 'unisex'] ) }

  # root folders only
  scope :top_level, -> { where(parent_id: nil) }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gender", "id", "name", "store_id", "updated_at", "user_id"]
  end
end
