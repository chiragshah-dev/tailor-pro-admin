# app/services/permission_checker.rb
class PermissionChecker
  def initialize(admin_user)
    @admin_user = admin_user
  end

  def can?(action_name, module_name)
    return true if @admin_user.role.is_super_admin?

    permitted_action_ids.include?(
      action_id_for(action_name.to_s, module_name.to_s)
    )
  end

  private

  def permitted_action_ids
    @permitted_action_ids ||= AdminPermission
      .where(role_id: @admin_user.role_id)
      .pluck(:admin_module_action_id)
      .to_set
  end

  def action_id_for(action_name, module_name)
    action_map.dig(module_name, action_name)
  end

  def action_map
    @action_map ||= AdminModuleAction
      .joins(:admin_module)
      .pluck("admin_modules.name", "admin_module_actions.name", "admin_module_actions.id")
      .each_with_object({}) do |(mod, action, id), hash|
      (hash[mod] ||= {})[action] = id
    end
  end
end
