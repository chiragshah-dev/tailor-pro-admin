ActiveAdmin.register Store do
  # ✅ Permit all relevant store fields here
  permit_params :name, :code, :store_type, :stitches_for, :is_main_store, :contact_number,
                :email, :website_url, :instagram_id, :whatsapp_number, :facebook_id,
                :location_name, :address, :city, :state, :country, :postal_code,
                :map_location, :user_id, :gst_included_on_bill, :gst_number,
                :gst_name, :gst_percentage

  # ✅ Index Page Configuration
  index do
    selectable_column
    id_column
    column :name
    column("Owner Name") do |store|
      if store.user
        link_to store.user.name, admin_user_path(store.user)
      else
        "No User"
      end
    end
    column :contact_number
    column :email
    column :address
    column :city
    column :state
    column :country
    column :postal_code
    # column :is_active
    # column :created_at
    # column :updated_at
    actions
  end

  # ✅ Enhanced Show Page Configuration for Store
  show do
    panel "🧾 Basic Details" do
      attributes_table_for store do
        row :id
        row :name
        row :code
        row :store_type
        row :stitches_for
        row :is_main_store
        row :user
      end
    end

    panel "📞 Contact Details" do
      attributes_table_for store do
        row :contact_number
        row :email
        row :website_url
        row :instagram_id
        row :facebook_id
        row :whatsapp_number
      end
    end

    panel "📍 Location Details" do
      attributes_table_for store do
        row :location_name
        row :address
        row :city
        row :state
        row :country
        row :postal_code
        row :map_location
      end
    end

    panel "💰 GST Details" do
      attributes_table_for store do
        row :gst_included_on_bill
        row :gst_name
        row :gst_number
        row :gst_percentage
      end
    end

    panel "🕒 System Info" do
      attributes_table_for store do
        row :created_at
        row :updated_at
      end
    end
  end

  # ✅ Form Configuration
  form do |f|
    f.semantic_errors

    f.inputs "Basic Information" do
      f.input :name, placeholder: "Enter store name (e.g., Tailor King - Main Branch)"
      f.input :code, placeholder: "Store code (e.g., TK001)"
      f.input :store_type, as: :select, collection: Store.store_types.keys.map { |t| [t.titleize, t] }, include_blank: false
      f.input :stitches_for, as: :select, collection: Store.stitches_fors.keys.map { |t| [t.titleize, t] }, include_blank: false
      f.input :is_main_store, label: "Main Store"
      f.input :user_id, as: :select, collection: User.all.map { |u| ["#{u.name} (#{u.email})", u.id] }, include_blank: "Select User"
    end

    f.inputs "Contact Details" do
      f.input :contact_number, placeholder: "10-digit contact number"
      f.input :email, placeholder: "example@store.com"
      f.input :website_url, placeholder: "https://example.com"
      f.input :instagram_id, placeholder: "@insta_handle"
      f.input :facebook_id, placeholder: "facebook.com/page"
      f.input :whatsapp_number, placeholder: "10-digit WhatsApp number"
    end

    f.inputs "Location Details" do
      f.input :location_name, placeholder: "Area or Landmark (e.g., City Mall)"
      f.input :address
      f.input :city
      f.input :state
      # f.input :country, placeholder: "India"
      f.input :postal_code, label: "PIN / Postal Code"
      f.input :map_location, placeholder: "Google Maps URL"
    end

    f.inputs "GST Details" do
      f.input :gst_included_on_bill, label: "Include GST on Bill"
      f.input :gst_name, placeholder: "Registered GST Name"
      f.input :gst_number, placeholder: "e.g., 27ABCDE1234F1Z5"
      f.input :gst_percentage, placeholder: "e.g., 18"
    end

    f.actions
  end

  # ✅ Filters
  filter :name
  filter :owner_name
  filter :contact_number
  filter :city
  filter :country
  filter :is_active
  filter :created_at
end
