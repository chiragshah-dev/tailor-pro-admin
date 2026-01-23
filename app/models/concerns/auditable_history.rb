module AuditableHistory
  extend ActiveSupport::Concern

  private

  def load_audit_history(record)
    @audit_versions = PaperTrail::Version
      .where(item_type: record.class.name, item_id: record.id)
      .order(created_at: :desc)
      .page(params[:page])
      .per(15)
  end
end
