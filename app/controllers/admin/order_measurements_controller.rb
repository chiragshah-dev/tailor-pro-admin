class Admin::OrderMeasurementsController < ApplicationController
  include AuditableHistory

  before_action :authenticate_admin_user!
  before_action :set_order_measurement, only: [:show, :history]

  def show
  end

  private

  def set_order_measurement
    @order_measurement = OrderMeasurement.find(params[:id])
  end
end
