module ApplicationHelper

  # breadcrumbs
  def dynamic_breadcrumbs
    crumbs = [{ label: "Home", path: root_path }]
    
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
end
