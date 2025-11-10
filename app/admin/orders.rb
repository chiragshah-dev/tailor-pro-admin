ActiveAdmin.register Order do
  permit_params :order_number, :order_date, :status, :total_bill_amount, :payment_received, :balance_due,
                :discount, :courier_to_customer, :store_id, :customer_id, :worker_id,
                order_items_attributes: [
                  :id, :order_item_number, :status, :name, :work_type, :special_instruction, :video_link,
                  :measurement_dress_given, :quantity, :price, :delivery_date, :trial_date, :function_date,
                  :completion_date, :is_urgent, :dress_id, :customer_dress_measurement_id, :member_id,
                  :garment_type_id, :stichfor, :worker_id, :_destroy
                ],
                order_measurements_attributes: [:id, :order_item_id, :measurement_field_id, :value, :unit, :_destroy]

  controller do
    before_action :authorize_super_admin!

    def authorize_super_admin!
      unless current_admin_user&.has_role?(:super_admin)
        flash[:alert] = "Access denied."
        redirect_to admin_root_path
      end
    end

    def store_stitches_for
      store = Store.find(params[:id])
      render json: { stitches_for: store.stitches_for }
    end

    def garment_types_by_gender
      gender = params[:gender]
      garments =
        if gender == "both"
          GarmentType.all
        else
          GarmentType.where(gender: gender)
        end
      render json: garments.pluck(:garment_name, :id)
    end

    def measurement_fields
      garment_type = GarmentType.find(params[:id])
      render json: garment_type.measurement_fields.select(:id, :label)
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
      f.input :store, as: :select,
                      collection: Store.pluck(:name, :id),
                      input_html: { id: "order_store_select" }

      li do
        label "Stitches For"
        span "", id: "store_stitches_for", style: "font-weight:bold;"
      end

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
        oi.inputs "Item Details" do
          oi.input :name
          oi.input :garment_type, as: :select,
                                  collection: [],
                                  include_blank: true,
                                  input_html: { class: "garment-type-select" }

          # ✅ Now this div will render just below garment_type
          oi.template.concat(
            oi.template.content_tag(:div, "", class: "measurement-fields-container", style: "margin-left: 20px;")
          )

          oi.input :work_type, as: :select, collection: OrderItem.work_types.keys.map { |w| [w.humanize, w] }
          oi.input :status, as: :select, collection: OrderItem.statuses.keys.map { |s| [s.humanize, s] }
          oi.input :quantity
          oi.input :price
          oi.input :delivery_date, as: :datepicker
          oi.input :is_urgent
          oi.input :special_instruction
        end
      end
    end

    f.actions

    # === Inline JavaScript ===
    script do
      raw <<~JS
        document.addEventListener("DOMContentLoaded", () => {
          const storeSelect = document.querySelector("#order_store_select");
          const stitchesField = document.querySelector("#store_stitches_for");

          // Fetch stitches_for based on store
          if (storeSelect) {
            storeSelect.addEventListener("change", async (e) => {
              const storeId = e.target.value;
              if (!storeId) return;

              // Fetch stitches_for
              const response = await fetch(`/admin/stores/${storeId}/stitches_for`);
              const data = await response.json();
              stitchesField.textContent = data.stitches_for.charAt(0).toUpperCase() + data.stitches_for.slice(1);

              // Fetch garment types based on store.stitches_for
              const garmentsResp = await fetch(`/admin/garment_types/by_gender/${data.stitches_for}`);
              const garmentOptions = await garmentsResp.json();

              // Update all garment_type selects
              document.querySelectorAll(".garment-type-select").forEach((select) => {
                select.innerHTML = "<option value=''>Select Garment Type</option>";
                garmentOptions.forEach(([name, id]) => {
                  const option = document.createElement("option");
                  option.value = id;
                  option.textContent = name;
                  select.appendChild(option);
                });
              });
            });
          }

          // Fetch measurement fields when garment type changes
          document.addEventListener("change", async (e) => {
            if (e.target.classList.contains("garment-type-select")) {
              const garmentId = e.target.value;
              const container = e.target.closest(".has_many_fields").querySelector(".measurement-fields-container");
              if (!garmentId || !container) return;

              // Fetch measurement fields for garment type
              const response = await fetch(`/admin/garment_types/${garmentId}/measurement_fields`);
              const fields = await response.json();

              container.innerHTML = "";
              fields.forEach((field) => {
                const wrapper = document.createElement("div");
                wrapper.classList.add("measurement-field-group");
                wrapper.style.marginBottom = "8px";
                wrapper.innerHTML = `
                  <label style="display:inline-block;width:150px;">${field.label}</label>
                  <input type="number" step="0.01" name="order[order_measurements_attributes][][value]" placeholder="Value" style="width:120px; margin-right:10px;">
                  <select name="order[order_measurements_attributes][][unit]" style="width:120px;">
                    <option value="inches">Inches</option>
                    <option value="cm">Centimeters</option>
                  </select>
                  <input type="hidden" name="order[order_measurements_attributes][][measurement_field_id]" value="${field.id}">
                `;
                container.appendChild(wrapper);
              });
            }
          });
        });
      JS
    end

  end
end
