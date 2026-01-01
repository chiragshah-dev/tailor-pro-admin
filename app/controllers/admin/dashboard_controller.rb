# app/controllers/admin/dashboard_controller.rb
module Admin
  class DashboardController < ApplicationController

      before_action :authenticate_admin_user!

    def index
    end
  end
end
