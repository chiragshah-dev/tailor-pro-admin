# app/controllers/admin/admin_permissions_controller.rb
class Admin::AdminPermissionsController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    # byebug
    @roles = Role.where(is_super_admin: false).order(:display_name)
     
    redirect_to admin_roles_path, alert: "No non-super-admin roles are available. Please create a role to manage permissions"  if @roles.blank?


    @selected_role = if params[:role_id].present?
        Role.find_by(id: params[:role_id])
      else
        @roles.first
      end

    @modules = AdminModule.includes(:admin_module_actions).order(:id)

    @existing = AdminPermission
      .where(role_id: @selected_role&.id)
      .pluck(:admin_module_action_id)
      .to_set

    @standard_groups = {
      "Read" => %w[index show],
      "Write" => %w[new create edit update],
      "Danger" => %w[destroy delete bulk_delete],
    }
  end

  def update
    role = Role.find(params[:id])
    new_action_ids = Array(params[:permissions]).map(&:to_i)

    ActiveRecord::Base.transaction do
      existing_action_ids = AdminPermission
        .where(role_id: role.id)
        .pluck(:admin_module_action_id)

      to_remove = existing_action_ids - new_action_ids
      AdminPermission
        .where(role_id: role.id, admin_module_action_id: to_remove)
        .delete_all unless to_remove.empty?

      to_insert = new_action_ids - existing_action_ids
      to_insert.each do |id|
        AdminPermission.create!(role_id: role.id, admin_module_action_id: id)
      end
    end

    redirect_to admin_permissions_path(role_id: role.id),
                notice: "Permissions updated successfully for #{role.display_name}"
  end
end
