ActiveAdmin.register Role do
  permit_params :name

  # ✅ Controller logic for authorization & access
  controller do
    before_action :restrict_access

    def restrict_access
      unless current_admin_user.has_role?(:super_admin)
        flash[:alert] = "Access denied. Only Super Admin can manage roles."
        redirect_to admin_root_path
      end
    end

    def scoped_collection
      super
    end

    def authorize_resource(resource = nil)
      authorize resource || Role
    end
  end

  # ✅ Index Page
  index do
    selectable_column
    id_column
    column :name do |role|
      status_tag role.name.titleize, style: "background-color: #3b82f6; color: white;"
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
    end
  end

  # ✅ Filters
  filter :name

  # ✅ Form
  form do |f|
    f.inputs "Role Details" do
      f.input :name, label: "Role Name"
    end
    f.actions
  end
end
