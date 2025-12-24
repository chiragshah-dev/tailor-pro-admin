# app/admin/garment_types.rb
ActiveAdmin.register GarmentType do
  # ✅ Permit params (add measurement_field_ids for the many-to-many association)
  permit_params :garment_name, :gender, :active, :image,
                measurement_field_ids: []  # For checkboxes

  # ✅ Menu & Config
  menu priority: 6, label: "Garment Types"

  # ✅ Index Page
  index do
    selectable_column
    id_column
    column :garment_name
    column :gender do |g|
      status_tag g.gender.titleize, style: "background-color: #3b82f6; color: white;"
    end
    column :active do |g|
      status_tag(g.active ? "Active" : "Inactive", class: g.active ? "ok" : "warning")
    end
    column "Measurement Fields" do |g|
      g.measurement_fields.pluck(:label).join(", ").truncate(50)
    end
    column "Image" do |g|
      if g.image.attached?
        image_tag url_for(g.image), size: "50x50", style: "border-radius: 6px;"
      else
        status_tag "No Image"
      end
    end
    actions
  end

  # ✅ Filters - FIXED
  filter :garment_name
  filter :gender, as: :select, collection: GarmentType.genders.keys.map { |g| [g.titleize, g] }
  filter :active
  filter :created_at
  filter :measurement_fields_id_eq, 
         as: :select, 
         collection: -> { MeasurementField.all.map { |mf| [mf.name, mf.id] } },
         label: "Measurement Field"

  # ✅ Form Layout - FIXED
  form do |f|
    f.inputs "Garment Type Details" do
      f.input :garment_name, label: "Name"
      f.input :gender, as: :select, 
              collection: GarmentType.genders.keys.map { |g| [g.titleize, g] }, 
              include_blank: "Select Gender"
      f.input :active, as: :boolean, label: "Is Active?"
      
      # ✅ Measurement fields in 4-column grid - FIXED
      f.inputs "Select Measurement Fields" do
        # Create 4 columns manually
        mf_count = MeasurementField.count
        slice_size = (mf_count.to_f / 4).ceil
        mf_groups = MeasurementField.all.each_slice(slice_size).to_a
        
        div style: "display: flex; gap: 20px;" do
          mf_groups.each_with_index do |group, index|
            div style: "flex: 1;" do
              group.each do |mf|
                div style: "margin-bottom: 8px; display: flex; align-items: center;" do
                  # FIX: Use safe_join or raw to render the checkbox
                  raw(check_box_tag("garment_type[measurement_field_ids][]",
                                   mf.id,
                                   f.object.measurement_field_ids.include?(mf.id),
                                   style: "margin-right: 8px;")) +
                  mf.label
                end
              end
            end
          end
        end
      end
    end

    f.inputs "Image Upload" do
      f.input :image, as: :file, 
              hint: (f.object.image.attached? ? 
                image_tag(url_for(f.object.image), size: "100x100") : 
                content_tag(:span, "No image uploaded"))
    end

    f.actions
  end

  # ✅ Show Page (Detailed View)
  show do
    panel "Garment Type Information" do
      attributes_table_for garment_type do
        row :id
        row :garment_name
        row(:gender) { garment_type.gender.titleize }
        row(:active) { garment_type.active ? status_tag("Active") : status_tag("Inactive") }
        row "Measurement Fields" do
          ul do
            garment_type.measurement_fields.each do |mf|
              li mf.label
            end
          end
        end
        row(:image) do
          if garment_type.image.attached?
            image_tag url_for(garment_type.image), size: "150x150", style: "border-radius: 8px;"
          else
            status_tag "No Image"
          end
        end
        row :created_at
        row :updated_at
      end
    end
  end

  # ✅ Optional: Add a custom Ransack predicate in the model
  controller do
    def scoped_collection
      super.includes(:measurement_fields)  # Prevent N+1 queries
    end
  end
end
