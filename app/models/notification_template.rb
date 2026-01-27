class NotificationTemplate < ApplicationRecord
  include Auditable

  before_validation :normalize_key

  validates :key, presence: true, uniqueness: true
  validates :title, :body, presence: true

  def render(vars = {})
    {
      title: title % vars,
      body: body % vars,
    }
  end

  private

  def normalize_key
    return if key.blank?

    self.key = key
      .strip
      .downcase
      .gsub(/\s+/, "_")
      .gsub(/[^a-z0-9_]/, "")
  end
end
