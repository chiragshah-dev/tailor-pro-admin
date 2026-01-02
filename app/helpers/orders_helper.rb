module OrdersHelper
  def order_status_badge(status)
    badge_class = case status.to_s
      when "pending"
        "bg-gradient-secondary"
      when "in_progress"
        "bg-gradient-info"
      when "ready_for_trial"
        "bg-gradient-warning"
      when "completed"
        "bg-gradient-success"
      when "delivered"
        "bg-gradient-primary"
      when "cancelled"
        "bg-gradient-danger"
      else
        "bg-gradient-secondary"
      end

    content_tag(
      :span,
      status.to_s.humanize,
      class: "badge #{badge_class} text-uppercase",
    )
  end

  def payment_status_badge(status)
    badge_class = case status.to_s
      when "paid"
        "bg-gradient-success"
      when "unpaid"
        "bg-gradient-danger"
      else
        "bg-gradient-secondary"
      end

    content_tag(
      :span,
      status.to_s.humanize,
      class: "badge badge-sm #{badge_class} text-capitalize",
    )
  end
end
