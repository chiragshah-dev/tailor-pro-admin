# app/controllers/admin/dashboard_controller.rb
module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_admin_user!

    def index
      @stores = Store.count
      @customers_count = Customer.count
      @orders_count = Order.count
      @workers_count = Worker.count
      @job_roles_count = JobRole.count
      @garment_types = GarmentType.count
      @currencies = Currency.count
      @stores_limit_reached_count =
  Store.includes(:orders, :user).count(&:order_limit_reached?)

    end

  end
end
