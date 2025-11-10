# app/admin/garment_types.rb
ActiveAdmin.register GarmentType do
  # ✅ Permit params
  permit_params :garment_name, :gender, :active, :image

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
    column "Image" do |g|
      if g.image.attached?
        image_tag url_for(g.image), size: "50x50", style: "border-radius: 6px;"
      else
        status_tag "No Image"
      end
    end
    actions
  end

  # ✅ Filters
  filter :garment_name
  filter :gender, as: :select, collection: GarmentType.genders.keys.map { |g| [g.titleize, g] }
  filter :active
  filter :created_at

  # ✅ Form Layout
  form do |f|
    f.inputs "Garment Type Details" do
      f.input :garment_name, label: "Name"
      f.input :gender, as: :select, collection: GarmentType.genders.keys.map { |g| [g.titleize, g] }, include_blank: "Select Gender"
      f.input :active, as: :boolean, label: "Is Active?"
    end

    f.inputs "Image Upload" do
      f.input :image, as: :file, hint: (f.object.image.attached? ? image_tag(url_for(f.object.image), size: "100x100") : content_tag(:span, "No image uploaded"))
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
        row(:image) do
          if garment_type.image.attached?
            image_tag url_for(garment_type.image), size: "150x150", style: "border-radius: 8px;"
          else
            status_tag "No Image", :warning
          end
        end
        row :created_at
        row :updated_at
      end
    end
  end
end
