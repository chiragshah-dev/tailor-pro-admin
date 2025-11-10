AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

user = User.first

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

puts "== Seeding core refs for Orders/OrderItems =="

app_user = User.first

# Stores
s1 = Store.find_or_create_by!(code: "S100") do |s|
  s.name = "Seed Store 1"
  s.user = app_user
  s.contact_number = "9000000001"
  s.address = "123 Seed Lane"
  s.city = "Mumbai"
  s.state = "Maharashtra"
  s.country = "India"
  s.is_main_store = true
end

s2 = Store.find_or_create_by!(code: "S101") do |s|
  s.name = "Seed Store 2"
  s.user = app_user
  s.contact_number = "9000000002"
  s.address = "456 Sample Road"
  s.city = "Pune"
  s.state = "Maharashtra"
  s.country = "India"
  s.is_main_store = false
end

# Customers (belong to store)
c1 = Customer.find_or_create_by!(email: "cust1@example.com") { |c| c.name = "Customer One"; c.contact_number = "9123456780"; c.store = s1 }
c2 = Customer.find_or_create_by!(email: "cust2@example.com") { |c| c.name = "Customer Two"; c.contact_number = "9123456781"; c.store = s1 }
c3 = Customer.find_or_create_by!(email: "cust3@example.com") { |c| c.name = "Customer Three"; c.contact_number = "9123456782"; c.store = s2 }

# Job roles + workers
jr_tailor = JobRole.find_or_create_by!(name: "Tailor", user_id: app_user.id)
w1 = Worker.find_or_create_by!(contact_number: "9812345670", store: s1) { |w| w.name = "Worker One"; w.job_role = jr_tailor }
w2 = Worker.find_or_create_by!(contact_number: "9812345671", store: s1) { |w| w.name = "Worker Two"; w.job_role = jr_tailor }

# Dresses
d1 = Dress.find_or_create_by!(name: "Kurta - Blue", gender: :male)   { |d| d.user = app_user; d.price = 1500 }
d2 = Dress.find_or_create_by!(name: "Sherwani - Cream", gender: :male){ |d| d.user = app_user; d.price = 3000 }

# Garment types (uses garment_name)
gt1 = GarmentType.find_or_create_by!(garment_name: "Kurta")   { |g| g.active = true }
gt2 = GarmentType.find_or_create_by!(garment_name: "Sherwani"){ |g| g.active = true }

# CustomerDressMeasurements (no values needed to satisfy your validations)
cdm1 = CustomerDressMeasurement.find_or_create_by!(customer: c1, dress: d1, name: "Default Kurta", measurement_unit: :inch)
cdm2 = CustomerDressMeasurement.find_or_create_by!(customer: c2, dress: d2, name: "Default Sherwani", measurement_unit: :inch)

# Orders (let callbacks generate numbers/dates)
o1 = Order.create!(store: s1, customer: c1, worker: w1)
o2 = Order.create!(store: s1, customer: c2, worker: w2)
o3 = Order.create!(store: s2, customer: c3)

# Order Items (future dates to satisfy validation)
OrderItem.create!(
  order: o1,
  name: "Blue Kurta Stitching",
  work_type: :stitching,
  status: :in_progress,
  quantity: 1,
  price: 1500,
  delivery_date: Date.today + 7,
  dress: d1,
  garment_type: gt1,
  customer_dress_measurement: cdm1,
  worker: w1
)

OrderItem.create!(
  order: o2,
  name: "Cream Sherwani Custom",
  work_type: :stitching,
  status: :accepted,
  quantity: 1,
  price: 3000,
  delivery_date: Date.today + 10,
  dress: d2,
  garment_type: gt2,
  customer_dress_measurement: cdm2,
  worker: w2
)

OrderItem.create!(
  order: o3,
  name: "Alteration Work",
  work_type: :alteration,
  status: :pending,
  quantity: 2,
  price: 500,
  delivery_date: Date.today + 5,
  worker: w1
)

puts "== Seeds complete =="
