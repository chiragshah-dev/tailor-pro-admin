# app/admin/measurement_fields.rb
ActiveAdmin.register MeasurementField do
  # ✅ Permit parameters
  permit_params :label, :name, :active, :garment_type_id, :measurement_image

  # ✅ Menu placement
  menu priority: 7, label: "Measurement Fields"

  # ✅ Index Page
  index do
    selectable_column
    id_column
    column :label
    column :name
    column "Garment Type" do |m|
      if m.garment_type.present?
        link_to m.garment_type.garment_name, admin_garment_type_path(m.garment_type)
      else
        status_tag "N/A"
      end
    end
    column :active do |m|
      status_tag(m.active ? "Active" : "Inactive")
    end
    column "Image" do |m|
      if m.measurement_image.attached?
        image_tag url_for(m.measurement_image), size: "50x50", style: "border-radius: 6px;"
      else
        status_tag "No Image"
      end
    end
    actions
  end

  # ✅ Filters
  filter :label
  filter :name
  filter :garment_type, as: :select, collection: GarmentType.all.map { |g| [g.garment_name, g.id] }
  filter :active
  filter :created_at

  # ✅ Form Layout
  form do |f|
    f.inputs "Measurement Field Details" do
      f.input :label
      f.input :name
      f.input :garment_type, as: :select, collection: GarmentType.all.map { |g| [g.garment_name, g.id] }, include_blank: "Select Garment Type"
      f.input :active, as: :boolean, label: "Is Active?"
    end

    f.inputs "Measurement Image" do
      f.input :measurement_image, as: :file, hint: (f.object.measurement_image.attached? ? image_tag(url_for(f.object.measurement_image), size: "100x100") : content_tag(:span, "No image uploaded"))
    end

    f.actions
  end

  # ✅ Show Page (Detailed View)
  show do
    panel "Measurement Field Information" do
      attributes_table_for measurement_field do
        row :id
        row :label
        row :name
        row("Garment Type") do
          if measurement_field.garment_type
            link_to measurement_field.garment_type.garment_name, admin_garment_type_path(measurement_field.garment_type)
          else
            status_tag "N/A", :warning
          end
        end
        row(:active) { measurement_field.active ? status_tag("Active") : status_tag("Inactive") }
        row(:measurement_image) do
          if measurement_field.measurement_image.attached?
            image_tag url_for(measurement_field.measurement_image), size: "150x150", style: "border-radius: 8px;"
          else
            status_tag "No Image"
          end
        end
        row :created_at
        row :updated_at
      end
    end
  end
end
