ActiveAdmin.register JobRole do
  # Strong params
  permit_params :name

  # INDEX PAGE
  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  # FILTERS
  filter :name
  filter :created_at

  # FORM
  form do |f|
    f.inputs "Job Role Details" do
      f.input :name
    end
    f.actions
  end

  # SHOW PAGE
  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end
  end
end
