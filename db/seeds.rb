# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

user = User.find(362)

stores_data = [
  {
    name: "Tailor King - Main Branch",
    code: "TK001",
    store_type: :both,
    stitches_for: :male,
    is_main_store: true,
    contact_number: "9876543210",
    email: "main@tailorking.com",
    website_url: "https://tailorking.com",
    location_name: "Downtown",
    address: "123 Fashion Street",
    city: "Mumbai",
    state: "Maharashtra",
    country: "India",
    postal_code: "400001",
    gst_included_on_bill: true,
    gst_number: "27ABCDE1234F1Z5",
    gst_name: "Tailor King Pvt Ltd",
    gst_percentage: 18
  },
  {
    name: "Tailor King - Workshop",
    code: "TK002",
    store_type: :workshop,
    stitches_for: :both,
    is_main_store: false,
    contact_number: "9988776655",
    email: "workshop@tailorking.com",
    website_url: "https://tailorking.com/workshop",
    location_name: "Industrial Area",
    address: "456 Tailor Lane",
    city: "Mumbai",
    state: "Maharashtra",
    country: "India",
    postal_code: "400002",
    gst_included_on_bill: true,
    gst_number: "27ABCDE1234F1Z6",
    gst_name: "Tailor King Workshop",
    gst_percentage: 18
  },
  {
    name: "Tailor King - Outlet 2",
    code: "TK003",
    store_type: :outlet,
    stitches_for: :female,
    is_main_store: false,
    contact_number: "9123456789",
    email: "outlet2@tailorking.com",
    website_url: "https://tailorking.com/outlet2",
    location_name: "City Mall",
    address: "789 Shopping Avenue",
    city: "Mumbai",
    state: "Maharashtra",
    country: "India",
    postal_code: "400003",
    gst_included_on_bill: true,
    gst_number: "27ABCDE1234F1Z7",
    gst_name: "Tailor King Outlet 2",
    gst_percentage: 18
  }
]

stores_data.each do |store_attrs|
  user.stores.create!(store_attrs)
end
