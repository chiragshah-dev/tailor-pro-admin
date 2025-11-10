ActiveAdmin.register Order do
  permit_params :order_number, :order_date, :status, :total_bill_amount, :payment_received, :balance_due,
                :discount, :courier_to_customer, :store_id, :customer_id, :worker_id,
                order_items_attributes: [
                  :id, :order_item_number, :status, :name, :work_type, :special_instruction, :video_link,
                  :measurement_dress_given, :quantity, :price, :delivery_date, :trial_date, :function_date,
                  :completion_date, :is_urgent, :dress_id, :customer_dress_measurement_id, :member_id,
                  :garment_type_id, :stichfor, :worker_id, :_destroy
                ]

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
    column :order_number
    column :order_date
    column("Store") { |o| o.store ? link_to(o.store.name, admin_store_path(o.store)) : "-" }
    column("Customer") { |o| o.customer&.name || "-" } # avoid link if Customer not registered in AA
    column("Status") { |o| status_tag o.status.to_s.humanize, style: "background-color:#3b82f6;color:#fff;" }
    column :total_bill_amount
    column :payment_received
    column :balance_due
    actions
  end

  filter :order_number
  filter :store, as: :select, collection: -> { Store.pluck(:name, :id) }
  filter :customer, as: :select, collection: -> { Customer.pluck(:name, :id) }
  filter :status, as: :select, collection: Order.statuses.keys
  filter :order_date

  show do
    attributes_table title: "Order Details" do
      row :id
      row :order_number
      row :order_date
      row("Store") { |o| o.store ? link_to(o.store.name, admin_store_path(o.store)) : "-" }
      row("Customer") { |o| o.customer&.name || "-" }
      row("Status") { |o| status_tag o.status.to_s.humanize, style: "background-color:#3b82f6;color:#fff;" }
      row :total_bill_amount
      row :payment_received
      row :discount
      row :balance_due
      row :courier_to_customer
      row :worker
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :id
        column :order_item_number
        column :name
        column("Work Type") { |it| it.work_type.to_s.humanize }
        column("Status") { |it| status_tag it.status.to_s.humanize, style: "background-color:#3b82f6;color:#fff;" }
        column :quantity
        column :price
        column :delivery_date
        column("Worker") { |it| it.worker&.name }
        column { |it| link_to "View", admin_order_item_path(it) }
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Order Details" do
      f.input :store, as: :select, collection: Store.pluck(:name, :id)
      f.input :customer, as: :select, collection: Customer.pluck(:name, :id)
      f.input :worker, as: :select, collection: Worker.pluck(:name, :id), include_blank: true
      f.input :order_date, as: :datepicker
      f.input :status, as: :select, collection: Order.statuses.keys.map { |s| [s.humanize, s] }
      f.input :courier_to_customer
      f.input :discount
      f.input :payment_received
    end

    f.inputs "Order Items" do
      f.has_many :order_items, allow_destroy: true, new_record: "Add Order Item" do |oi|
        oi.input :name
        oi.input :dress, as: :select, collection: Dress.pluck(:name, :id), include_blank: true
        oi.input :garment_type, as: :select, collection: GarmentType.pluck(:garment_name, :id), include_blank: true
        oi.input :work_type, as: :select, collection: OrderItem.work_types.keys.map { |w| [w.humanize, w] }
        oi.input :status, as: :select, collection: OrderItem.statuses.keys.map { |s| [s.humanize, s] }
        oi.input :quantity
        oi.input :price
        oi.input :delivery_date, as: :datepicker
        oi.input :is_urgent
        oi.input :special_instruction
      end
    end

    f.actions
  end
end
