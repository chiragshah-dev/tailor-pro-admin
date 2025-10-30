ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :contact_number, :jti, :active_store_id, :otp_code, :otp_sent_at, :otp_verified_at, :email, :mpin_digest, :device_id, :country_code
  #
  # or
  #
  # permit_params do
  #   permitted = [:encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :contact_number, :jti, :active_store_id, :otp_code, :otp_sent_at, :otp_verified_at, :email, :mpin_digest, :device_id, :country_code]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
