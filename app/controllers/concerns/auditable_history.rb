module AuditableHistory
  extend ActiveSupport::Concern

  included do
    before_action :load_record_for_history, only: [:history]
  end

  def history
    load_audit_history(@auditable_record)

    render "admin/shared/audit_history/list_history", locals: {
                                                        audit_versions: @audit_versions,
                                                      }
  end

  private

  def load_record_for_history
    send("set_#{controller_name.singularize}")
    ivar = "@#{controller_name.singularize}"
    @auditable_record = instance_variable_get(ivar)

    raise "Missing instance variable #{ivar}" unless @auditable_record
  end

  def load_audit_history(record)
    @audit_versions = PaperTrail::Version
      .where(item_type: record.class.name, item_id: record.id)
      .order(created_at: :desc)
      .page(params[:page])
      .per(15)
  end
end
