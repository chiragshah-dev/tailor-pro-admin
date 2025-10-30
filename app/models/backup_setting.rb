class BackupSetting < ApplicationRecord
  belongs_to :store

  validates :frequency, inclusion: { in: %w[daily weekly monthly], allow_nil: true }
  validates :delivery_type, inclusion: { in: %w[email cloud], allow_nil: true }
end
