class Admin::CustomProductsController < ApplicationController
  include AuditableHistory

  before_action :set_custom_product, only: [:show, :history]
  before_action :authenticate_admin_user!

  def show; end

  private

  def set_custom_product
    @custom_product = CustomProduct
      .find(params[:id])
  end
end
