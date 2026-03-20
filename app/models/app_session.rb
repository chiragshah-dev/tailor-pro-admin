class AppSession < ApplicationRecord
  include Auditable
  belongs_to :user

  enum :status, { active: 0, ended: 1 }

  validates :session_id, uniqueness: true

  before_create :ensure_session_id

  def add_route(route_name)
    self.route_sequence = route_sequence + [{
      route: route_name,
      timestamp: Time.current.iso8601,
    }]

    self.entry_route ||= route_name
    self.exit_route = route_name

    save!
  end

  private

  def ensure_session_id
    self.session_id ||= "sess_#{SecureRandom.uuid}"
  end
end
