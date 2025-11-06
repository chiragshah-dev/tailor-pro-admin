ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, role_ids: []

  index do
    selectable_column
    id_column
    column :email
    column "Roles" do |admin|
      roles_html = admin.roles.map do |role|
        content_tag(:span, role.name.titleize,
          class: "status_tag",
          style: "background-color: #3b82f6; color: white; padding: 2px 2px; margin-right: 2px;"
        )
      end.join(" ")
      roles_html.html_safe
    end
    actions
  end

  show do
    attributes_table do
      row :email
      row("Roles") do |admin|
        ul do
          admin.roles.each do |role|
            li do
              status_tag(role.name.titleize, style: "background-color: #3b82f6; color: white;")
            end
            br
          end
        end
      end
    end
  end

  filter :email
  filter :roles, as: :select, collection: -> { Role.pluck(:name, :id) }

  form do |f|
    f.semantic_errors

    f.inputs "Admin User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end

    f.inputs "Assign Roles" do
      div class: "roles-checkbox-group" do
        f.input :roles,
                as: :check_boxes,
                collection: Role.all.pluck(:name, :id),
                label: false,
                wrapper_html: { class: "role-item" }
      end
    end

    f.actions
  end
end
