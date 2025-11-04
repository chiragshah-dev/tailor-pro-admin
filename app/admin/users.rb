ActiveAdmin.register User do
  # Permit all user attributes for create/update actions
  permit_params :encrypted_password, :reset_password_token, :reset_password_sent_at, 
                :remember_created_at, :name, :contact_number, :jti, :active_store_id, 
                :otp_code, :otp_sent_at, :otp_verified_at, :email, :mpin_digest, 
                :device_id, :country_code

  # Index page configuration
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :contact_number
    column :country_code
    column :device_id
    column :active_store_id
    # column :otp_code
    # column :otp_sent_at
    # column :otp_verified_at
    # column :reset_password_token
    # column :reset_password_sent_at
    # column :remember_created_at
    # column :jti
    # column :mpin_digest
    # column :created_at
    # column :updated_at
    actions
  end

  # Filters for sidebar
  filter :id
  filter :name
  filter :email
  filter :contact_number
  filter :country_code
  filter :device_id
  # filter :active_store_id
  # filter :otp_verified_at
  # filter :created_at
  # filter :updated_at

  # Form for creating/updating users
  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :contact_number
      f.input :country_code
      f.input :device_id
      f.input :active_store_id
      f.input :otp_code
      f.input :otp_sent_at, as: :datetime_picker
      f.input :otp_verified_at, as: :datetime_picker
      f.input :reset_password_token
      f.input :reset_password_sent_at, as: :datetime_picker
      f.input :remember_created_at, as: :datetime_picker
      f.input :jti
      f.input :mpin_digest
      f.input :encrypted_password
    end
    f.actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :contact_number
      row :country_code
      row :device_id
      row :active_store_id
      row :otp_code
      row :otp_sent_at
      row :otp_verified_at
      row :reset_password_token
      row :reset_password_sent_at
      row :remember_created_at
      row :jti
      row :mpin_digest
      row :encrypted_password
      row :created_at
      row :updated_at
    end

    panel "Stores Owned by #{user.name}" do
      if user.stores.any?
        table_for user.stores.order(:id) do
          column("ID") { |store| link_to store.id, admin_store_path(store) }
          column("Store Name") { |store| link_to store.name, admin_store_path(store) }
          column("Code", &:code)
          column("Type") { |s| s.store_type.titleize }
          column("Stitches For") { |s| s.stitches_for.titleize }
          # column("Main Store") do |s|
          #   status_tag(s.is_main_store ? "Yes" : "No", s.is_main_store ? :ok : :error)
          # end
          column("Contact") { |s| s.contact_number }
          column("Email") { |s| s.email.presence || "-" }
          column("City", &:city)
          column("State", &:state)
          column("Country", &:country)
          column("GST Name") { |s| s.gst_name.presence || "-" }
          column("GST Number") { |s| s.gst_number.presence || "-" }
          # column("GST Included") do |s|
          #   status_tag(s.gst_included_on_bill ? "Yes" : "No", s.gst_included_on_bill ? :ok : :warning)
          # end
          # column("Created At") { |s| s.created_at.strftime("%d %b %Y, %I:%M %p") }
        end
      else
        div style: "padding:10px; color: #888;" do
          "No stores associated with this user yet."
        end
      end
    end
  end
end
