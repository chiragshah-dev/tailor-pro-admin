ActiveAdmin.register Worker do
  permit_params :name, :contact_number, :job_role_id, :store_id, :active

  index do
    selectable_column
    id_column
    column :name
    column :contact_number
    column :job_role
    column :store
    column :active
    column :created_at
    actions
  end

  filter :name
  filter :contact_number
  filter :job_role
  filter :store
  filter :active
  filter :created_at

  form do |f|
    f.inputs "Worker Details" do
      f.input :name
      f.input :contact_number
      f.input :job_role
      f.input :store
      f.input :active
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :contact_number
      row :job_role
      row :store
      row :active
      row :created_at
      row :updated_at
    end
  end
end
