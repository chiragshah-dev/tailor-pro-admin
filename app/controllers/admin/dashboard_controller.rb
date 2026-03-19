# app/controllers/admin/dashboard_controller.rb
module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_admin_user!

    def index
      today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
      @stores = Store.count
      @customers_count = Customer.count
      @orders_count = Order.count
      @workers_count = Worker.count
      @job_roles_count = JobRole.count
      @garment_types = GarmentType.count
      @currencies = Currency.count
      @today_stores_count = Store.where(created_at: today_range).count
      @today_customers_count = Customer.where(created_at: today_range).count
      @today_orders_count = Order.where(created_at: today_range).count
      @today_users_count = User.where(created_at: today_range).count

      # ---- STORES WHERE BILLING LIMIT IS REACHED ----
      # Logic:
      # Store -> User (country_code)
      # country_code -> currency_countries
      # currency -> currency_settings (amount_limit)
      # compare SUM(orders.total_bill_amount) >= amount_limit
      @stores_limit_reached_count = Store
        .joins(:orders)
        .joins("INNER JOIN users ON users.id = stores.user_id")
        .where.not(users: { country_code: nil })
        .joins("INNER JOIN currency_countries ON currency_countries.country_code = users.country_code")
        .joins("INNER JOIN currencies ON currencies.id = currency_countries.currency_id")
        .joins("INNER JOIN currency_settings ON currency_settings.currency_id = currencies.id")
        .group("stores.id", "currency_settings.amount_limit")
        .having("SUM(orders.total_bill_amount) >= currency_settings.amount_limit")
        .count
        .size
    end
  end
end
