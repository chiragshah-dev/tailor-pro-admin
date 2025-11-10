ActiveAdmin.register OrderItem do
  permit_params :order_item_number, :status, :name, :work_type, :special_instruction, :video_link,
                :measurement_dress_given, :quantity, :price, :delivery_date, :trial_date, :function_date,
                :completion_date, :is_urgent, :order_id, :dress_id, :customer_dress_measurement_id,
                :member_id, :garment_type_id, :stichfor, :worker_id

  controller do
    before_action :authorize_super_admin!

    def authorize_super_admin!
      unless current_admin_user&.has_role?(:super_admin)
        flash[:alert] = "Access denied."
        redirect_to admin_root_path
      end
    end
  end

  index do
    selectable_column
    id_column
    column :order_item_number
    column("Order") { |oi| oi.order ? link_to(oi.order.order_number, admin_order_path(oi.order)) : "-" }
    column :name
    column("Work Type") { |oi| oi.work_type.to_s.humanize }
    column("Status") { |oi| status_tag oi.status.to_s.humanize, style: "background-color:#3b82f6;color:#fff;" }
    column :quantity
    column :price
    column :delivery_date
    actions
  end

  filter :order, as: :select, collection: -> { Order.pluck(:order_number, :id) }
  filter :status, as: :select, collection: OrderItem.statuses.keys
  filter :work_type, as: :select, collection: OrderItem.work_types.keys
  filter :delivery_date

  show do
    attributes_table do
      row :id
      row :order_item_number
      row("Order") { |oi| oi.order ? link_to(oi.order.order_number, admin_order_path(oi.order)) : "-" }
      row :name
      row("Work Type") { |oi| oi.work_type.to_s.humanize }
      row("Status") { |oi| status_tag oi.status.to_s.humanize, style: "background-color:#3b82f6;color:#fff;" }
      row :quantity
      row :price
      row :delivery_date
      row :trial_date
      row :function_date
      row :completion_date
      row :special_instruction
      row :video_link
      row :created_at
      row :updated_at
    end

    panel "Order Details" do
      o = order_item.order
      if o
        table_for [o] do
          column :order_number
          column :order_date
          column("Store") { |x| x.store&.name }
          column("Customer") { |x| x.customer&.name }
          column("Status") { |x| status_tag x.status.to_s.humanize, style: "background-color:#3b82f6;color:#fff;" }
          column :total_bill_amount
          column :payment_received
          column :balance_due
        end
      else
        div "No order found"
      end
    end
  end

  form do |f|
    f.inputs "Order Item Details" do
      f.input :order, as: :select, collection: Order.pluck(:order_number, :id)
      f.input :name
      f.input :dress, as: :select, collection: Dress.pluck(:name, :id), include_blank: true
      f.input :garment_type, as: :select, collection: GarmentType.pluck(:garment_name, :id), include_blank: true
      f.input :work_type, as: :select, collection: OrderItem.work_types.keys.map { |w| [w.humanize, w] }
      f.input :status, as: :select, collection: OrderItem.statuses.keys.map { |s| [s.humanize, s] }
      f.input :quantity
      f.input :price
      f.input :delivery_date, as: :datepicker
      f.input :is_urgent
      f.input :special_instruction
    end
    f.actions
  end
end
