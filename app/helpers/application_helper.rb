module ApplicationHelper

  # breadcrumbs
  def dynamic_breadcrumbs
    crumbs = [{ label: "Home", path: root_path }]

    if controller_name == "users" && action_name == "session_detail"
      user = @user rescue nil

      crumbs << { label: "Users", path: admin_users_path }
      crumbs << { label: "Sessions", path: sessions_admin_user_path(user) }
      crumbs << { label: "Detail", path: nil }

      return crumbs
    end

    controller_label = controller_name.titleize
    index_path = url_for(controller: controller_path, action: :index) rescue nil

    crumbs << { label: controller_label, path: index_path }

    unless action_name == "index"
      crumbs << { label: action_name.titleize, path: nil }
    end

    crumbs
  end

  def dynamic_page_title
    action_name == "index" ? controller_name.titleize : action_name.titleize
  end

  # def sortable_header(column, label)
  #   direction =
  #     (params[:sort] == column && params[:direction] == "asc") ? "desc" : "asc"

  #   link_to label,
  #     params.permit(:search, :page).merge(sort: column, direction: direction),
  #     class: "text-dark text-decoration-none"
  # end

  def sortable_header(column, label)
    current_sort = params[:sort]
    current_dir = params[:direction]

    icon = if current_sort == column
        current_dir == "asc" ? "↑" : "↓"
      else
        "⇅"
      end

    next_dir =
      (current_sort == column && current_dir == "asc") ? "desc" : "asc"

    link_to params.permit(:search, :page).merge(sort: column, direction: next_dir),
            class: "sortable-header text-dark text-decoration-none d-inline-flex align-items-center gap-1" do
      safe_join([
        label,
        content_tag(:span, icon, class: "sort-icon"),
      ])
    end
  end
end
