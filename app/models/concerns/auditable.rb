module Auditable
  extend ActiveSupport::Concern

  included do
    has_paper_trail on: [:create, :update, :destroy],
                    save_changes: true,
                    ignore: [:updated_at],
                    meta: {
                      actor: ->(_) { PaperTrail.request.whodunnit },
                      path: ->(_) { RequestStore.store[:path] },
                      http_method: ->(_) { RequestStore.store[:method] },
                      request_id: ->(_) { RequestStore.store[:request_id] },
                    }
  end
end
