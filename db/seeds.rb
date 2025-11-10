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

# november 10, 2025

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

gents_measurements = [
  "Neck", "Shoulder width", "Half Shoulder", "Chest", "Cross Back", "Waist", "Coat Waist",
  "Shirt Length", "Hip", "Jacket Length", "Sleeve Length", "Sleeve Length for Suit",
  "Coat Sleeve Length", "Arm Length", "Arm Hole", "Biceps", "Wrist", "Seat", "Pants Length",
  "waist to ankle", "Fly", "Thighs", "Crotch", "Inseam", "Shorts Length", "Above Knee",
  "Below Knee", "Crotch to Knee", "Knee to Calf", "Calf", "Ankle", "Cuff Ankle", "Blank",
]

gents_measurements.each do |measurement|
  Measurement.find_or_create_by(name: measurement, gender: "male")
end

ladies_measurements = [
  "Full Height", "Kurthi Height", "Shirt Length", "Blouse Length", "Upper Chest", "Chest",
  "Blouse Chest", "Waist", "Blouse Below Bust", "Stomach", "Hip", "Shoulder to Apex",
  "Nape to Apex", "Nape to Waist (Front)", "Nape to Waist (Back)", "Apex to Apex",
  "Waist Length", "Stomach Length", "Waist to Hip", "Shoulder to Waist Back", "Hip Length",
  "Front Neck Depth", "Front Neck Depth 2", "Back Neck Depth", "Back Neck Depth 2",
  "Nape to Neck Depth (Front)", "Nape to Neck Depth (Back)", "Neck", "Shoulder",
  "Shoulder Round", "Halter Bound", "Front Shoulder", "Back Shoulder", "Half Shoulder",
  "Full Sleeve Length", "Full Sleeve Length Circular", "Three Fourth Sleeve Length",
  "Three Fourth Sleeve Length Circular", "Elbow Length", "Elbow Circular", "Cap Sleeve",
  "Cap Sleeve Circular", "Bicep", "Wrist", "Sleeve Length Half", "Arm Length", "Arm Hole",
  "Bottom Height", "Shorts Length", "Seat", "Hip Bottom", "Waist Bottom", "Thigh", "Crotch",
  "Calf", "Waist to Ankle", "Ankle", "Knee Length", "Thigh Length", "Thigh Circular",
  "Above Knee", "Below Knee", "Calf to Ankle", "Knee to Calf", "Back Neck Width",
  "Front Neck Width", "Sweep Length", "Strap Length", "Thigh Bound", "Blank",
]

ladies_measurements.each do |measurement|
  Measurement.find_or_create_by(name: measurement, gender: "female")
end

male_stitch_features = [
  {
    name: "Shirt Cuff Type",
    stitch_options: [
      "Angled", "Rounded", "Square", "French Angled", "French Rounded", "French Square",
      "Milanese", "French",
    ],
  },
  {
    name: "Leg Shape",
    stitch_options: ["Joint Thigh", "Bow Leg", "Knock Knee", "Prominent Thigh"],
  },
  {
    name: "Back Pocket Type",
    stitch_options: [
      "Jetted", "Jetted With Flap", "Jetted With Tab", "Jetted With Zipper",
      "Jetted With Top Stitch", "Welt / Besom", "Welt With Button", "Welt With Top Stitch",
    ],
  },
  {
    name: "Pleats",
    stitch_options: ["Yes", "No"],
  },
  {
    name: "Collar Type",
    stitch_options: ["Classic", "Mandarin", "Button Down", "Spread", "Cut Away"],
  },
  {
    name: "Pocket Type",
    stitch_options: ["Classic", "Square", "Round", "Angled"],
  },
  {
    name: "Side Pocket Type",
    stitch_options: ["Cross", "Straight"],
  },
  {
    name: "Stomach Type",
    stitch_options: ["Forward", "Stount", "Large"],
  },
  {
    name: "Mens Coat Back Shape",
    stitch_options: ["Normal", "Stooped", "Erect"],
  },
  {
    name: "Coat Pocket",
    stitch_options: ["Jetted", "Flap", "patched"],
  },
  {
    name: "Number of Pockets",
    stitch_options: [0, 1, 2],
  },
  {
    name: "Number of Back Pockets",
    stitch_options: [0, 1, 2],
  },
  {
    name: "Shoulder Type",
    stitch_options: ["Regular", "Square", "Sloping"],
  },
]

male_stitch_features.each do |feature_data|
  feature = StitchFeature.find_or_create_by(
    name: feature_data[:name],
    value_selection_type: "radio",
    gender: "male",
  )

  feature_data[:stitch_options].each do |option_name|
    feature.stitch_options.find_or_create_by(name: option_name)
  end

  feature.update!(is_default: true)
end

female_stitch_features = [
  {
    name: "Back Neck Design",
    stitch_options: [
      "U-Neck", "V-Neck", "Boat Neck", "Basket", "Wide Square", "Halter", "Collar", "Round",
      "Pot Neck", "5 Corner",
    ],
  },
  {
    name: "Front Neck Design",
    stitch_options: [
      "U-Neck", "V-Neck", "Boat Neck", "Basket", "Wide Square", "Halter", "Collar", "Round",
      "Deep U", "5 Corner Neck", "Sweet Heart",
    ],
  },
  {
    name: "Opening",
    stitch_options: ["Front", "Back", "Side"],
  },
  {
    name: "Cutting",
    stitch_options: ["Katori", "Princes Cut", "Four Tucks", "Three Tucks"],
  },
  {
    name: "Stitching Type",
    stitch_options: ["Hand", "Machine"],
  },
  {
    name: "Lining",
    stitch_options: ["Yes", "No"],
  },
  {
    name: "Waist Band (Patti)",
    stitch_options: ["Yes", "No"],
  },
  {
    name: "Sleeve Type",
    stitch_options: ["Half", "Full", "No", "Cap"],
  },
  {
    name: "Lock Type",
    stitch_options: ["Hook", "Button", "Zipper", "Chain"],
  },
  {
    name: "Padding",
    stitch_options: ["Yes", "No"],
  },
]

female_stitch_features.each do |feature_data|
  feature = StitchFeature.find_or_create_by(
    name: feature_data[:name],
    value_selection_type: "radio",
    gender: "female",
  )

  feature_data[:stitch_options].each do |option_name|
    feature.stitch_options.find_or_create_by(name: option_name)
  end

  feature.update!(is_default: true)
end

services = [
  "Shirt Stitching",
  "Pant Stitching",
  "Lehenga Stitching",
  "Dress Alteration",
  "School Uniform Stitching",
  "Blouse Stitching",
  "Kurta Stitching",
  "Jacket Stitching",
  "Gown Stitching",
  "Suit Tailoring",
]

expertises = [
  "Bridal Wear Specialist",
  "Designer Blouse Expert",
  "Kurta Pajama Expert",
  "Shirt & Pant Tailor",
  "Alteration Expert",
  "Fashion Designer",
  "Embroidery Expert",
  "Style Consultant",
  "Fabric Consultant",
  "Personal Stylist",
]

puts "Seeding Services..."
services.each do |service_name|
  Service.find_or_create_by(name: service_name.strip)
end

puts "Seeding Expertises..."
expertises.each do |expertise_name|
  Expertise.find_or_create_by(name: expertise_name.strip)
end

# SubscriptionPackage.destroy_all

# SubscriptionPackage.create!([
#   {
#     name: "Free",
#     price: 0.0,
#     store_limit: 3,
#     duration_in_days: 30,
#     description: "Free plan with up to 3 stores"
#   },
#   {
#     name: "Essential",
#     price: 499.0,
#     store_limit: 7,
#     duration_in_days: 30,
#     description: "Essential plan with up to 7 stores"
#   },
#   {
#     name: "Premium",
#     price: 999.0,
#     store_limit: 1000,
#     duration_in_days: 30,
#     description: "Premium plan with unlimited stores"
#   }
# ])

# SubscriptionPackage.create!([
#   {
#     name: "Free",
#     price_month: 0.0,
#     price_year: 0.0,
#     duration_in_days: 30,
#     duration_month: 1,
#     duration_year: 1,
#     store_limit: 3,
#     # is_active: true,
#     description: "Free plan with up to 3 stores"
#   },
#   {
#     name: "Essential",
#     price_month: 499.0,
#     price_year: 4999.0,
#     duration_in_days: 30,
#     duration_month: 1,
#     duration_year: 12,
#     store_limit: 7,
#     # is_active: true,
#     description: "Essential plan with up to 7 stores"
#   },
#   {
#     name: "Premium",
#     price_month: 999.0,
#     price_year: 9999.0,
#     duration_in_days: 30,
#     duration_month: 1,
#     duration_year: 12,
#     store_limit: 1000, # unlimited representation
#     # is_active: true,
#     description: "Premium plan with unlimited stores"
#   }
# ])

GalleryCategory.destroy_all
GalleryCategory.create!(name: "Men")
GalleryCategory.create!(name: "Women")
GalleryCategory.create!(name: "Custom")

puts "🔧 Nullifying garment_type_id in order_items..."
OrderItem.update_all(garment_type_id: nil)

puts "🗑️ Destroying existing GarmentTypes..."
GarmentType.destroy_all
puts "✅ GarmentTypes cleared successfully."

female_garments = [
  "Blouse",
  "Dress",
  "Kurti",
  "Lehenga",
  "Salwar Suit"
]

male_garments = [
  "Shirt",
  "Trouser",
  "Kurta",
  "Sherwani",
  "Coat"
]

female_garments.each do |name|
  GarmentType.find_or_create_by!(garment_name: name) do |g|
    g.gender = :female
  end
end

male_garments.each do |name|
  GarmentType.find_or_create_by!(garment_name: name) do |g|
    g.gender = :male
  end
end

garments_map = GarmentType.all.index_by(&:garment_name)

puts "🔧 Nullifying measurement_field_id in order_measurements..."
OrderMeasurement.update_all(measurement_field_id: nil)

MeasurementField.destroy_all
puts "🗑️  Existing MeasurementFields destroyed."

# Define measurements per garment type

measurement_mappings = {
  "Blouse" => [
    "Chest/Bust", "Underbust", "Waist", "Shoulder Width", "Armhole",
    "Sleeve Length", "Sleeve Round", "Blouse Length",
    "Front Neck Depth", "Back Neck Depth",
  ],

  "Dress" => [
    "Chest/Bust", "Waist", "Hip", "Shoulder Width", "Armhole",
    "Sleeve Length", "Sleeve Round", "Dress Length",
    "Front Neck Depth", "Back Neck Depth",
  ],

  "Kurti" => [
    "Chest/Bust", "Waist", "Hip", "Shoulder Width", "Armhole",
    "Sleeve Length", "Sleeve Round", "Kurti Length",
    "Front Neck Depth", "Back Neck Depth",
  ],

  "Lehenga" => [
    "Waist", "Hip", "Lehenga Length", "Bottom Bells / Hem Width",
  ],

  "Salwar Suit" => [
    "Chest/Bust", "Waist", "Hip", "Shoulder Width", "Armhole",
    "Sleeve Length", "Sleeve Round", "Kameez Length",
    "Front Neck Depth", "Back Neck Depth",
    "Salwar Waist", "Salwar Hip", "Thigh", "Knee", "Calf", "Ankle", "Salwar Length",
  ],

  "Shirt" => [
    "Neck Round", "Shoulder Width", "Chest", "Waist",
    "Hip", "Sleeve Length", "Cuff Round", "Shirt Length",
  ],

  "Trouser" => [
    "Waist", "Hip", "Seat", "Thigh", "Knee", "Calf", "Ankle", "Trouser Length", "Inseam Length",
  ],

  "Kurta" => [
    "Chest/Bust", "Waist", "Hip", "Shoulder Width", "Armhole",
    "Sleeve Length", "Sleeve Round", "Kurta Length",
    "Front Neck Depth", "Back Neck Depth",
  ],

  "Sherwani" => [
    "Chest/Bust", "Waist", "Hip", "Shoulder Width", "Armhole",
    "Sleeve Length", "Sleeve Round", "Sherwani Length",
    "Front Neck Depth", "Back Neck Depth",
  ],

  "Coat" => [
    "Chest/Bust", "Shoulder Width", "Sleeve Length", "Sleeve Round", "Coat Length",
  ],
}

# Create MeasurementFields per GarmentType
measurement_mappings.each do |garment_name, field_labels|
  garment = garments_map[garment_name]

  field_labels.each do |label|
    MeasurementField.create!(
      label: label,
      name: label.downcase.gsub(/\s+/, "_"),
      garment_type_id: garment.id,
    )
  end
end

garment_type = GarmentType.find_by(garment_name: "Blouse")

image_base_path = Rails.root.join("public", "Tailor's Pro")

# label-to-filename mapping
mapping = {
  "Chest/Bust" => "Chest Circumference.png",
  "Underbust" => "Lower Bust Circumference.png",
  "Waist" => "Waist Circumference.png",
  "Shoulder Width" => "Shoulder Width.png",
  "Armhole" => "Bicep Circumference.png",
  "Sleeve Length" => "Sleeve Length.png",
  "Sleeve Round" => "Wrist Circumference.png",
  "Blouse Length" => "Blouse Length.png",
  "Front Neck Depth" => "Neck Depth.png",
  "Back Neck Depth" => "Neck Depth.png"
}

garment_type.measurement_fields.each do |field|
  filename = mapping[field.label]
  next unless filename.present?

  path = image_base_path.join(filename)
  unless File.exist?(path)
    puts "❌ Missing image for #{field.label}"
    next
  end

  # remove old image if exists
  field.measurement_image.purge if field.measurement_image.attached?

  # attach new image
  field.measurement_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/png"
  )

  puts "✅ Attached image to #{field.label}"
end

garment_type = GarmentType.find_by(garment_name: "Dress")

image_base_path = Rails.root.join("public", "Tailor's Pro")

# label-to-filename mapping
mapping = {
  "Chest/Bust" => "Chest Circumference.png",
  "Waist" => "Waist Circumference.png",
  "Hip" => "Hip Circumference.png",
  "Shoulder Width" => "Shoulder Width.png",
  "Armhole" => "Bicep Circumference.png",
  "Sleeve Length" => "Sleeve Length.png",
  "Sleeve Round" => "Wrist Circumference.png",
  "Dress Length" => "Kurti Length.png",
  "Front Neck Depth" => "Neck Depth.png",
  "Back Neck Depth" => "Neck Depth.png"
}

garment_type.measurement_fields.each do |field|
  filename = mapping[field.label]
  next unless filename.present?

  path = image_base_path.join(filename)
  unless File.exist?(path)
    puts "❌ Missing image for #{field.label}"
    next
  end

  # remove old image if exists
  field.measurement_image.purge if field.measurement_image.attached?

  # attach new image
  field.measurement_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/png"
  )

  puts "✅ Attached image to #{field.label}"
end

garment_type = GarmentType.find_by(garment_name: "Kurti")

image_base_path = Rails.root.join("public", "Tailor's Pro")

# label-to-filename mapping
mapping = {
  "Chest/Bust" => "Chest Circumference.png",
  "Waist" => "Waist Circumference.png",
  "Hip" => "Hip Circumference.png",
  "Shoulder Width" => "Shoulder Width.png",
  "Armhole" => "Bicep Circumference.png",
  "Sleeve Length" => "Sleeve Length.png",
  "Sleeve Round" => "Wrist Circumference.png",
  "Kurti Length" => "Kurti Length.png",
  "Front Neck Depth" => "Neck Depth.png",
  "Back Neck Depth" => "Neck Depth.png"
}

garment_type.measurement_fields.each do |field|
  filename = mapping[field.label]
  next unless filename.present?

  path = image_base_path.join(filename)
  unless File.exist?(path)
    puts "❌ Missing image for #{field.label}"
    next
  end

  # remove old image if exists
  field.measurement_image.purge if field.measurement_image.attached?

  # attach new image
  field.measurement_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/png"
  )

  puts "✅ Attached image to #{field.label}"
end


garment_type = GarmentType.find_by(garment_name: "Lehenga")

image_base_path = Rails.root.join("public", "Tailor's Pro")

# label-to-filename mapping
mapping = {
  "Waist" => "Waist Circumference.png",
  "Hip" => "Hip Circumference.png",
  "Lehenga Length" => "Lahenga Length.png",
  "Bottom Bells / Hem Width" => "Lahenga Length.png",
}

garment_type.measurement_fields.each do |field|
  filename = mapping[field.label]
  next unless filename.present?

  path = image_base_path.join(filename)
  unless File.exist?(path)
    puts "❌ Missing image for #{field.label}"
    next
  end

  # remove old image if exists
  field.measurement_image.purge if field.measurement_image.attached?

  # attach new image
  field.measurement_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/png"
  )

  puts "✅ Attached image to #{field.label}"
end

garment_type = GarmentType.find_by(garment_name: "Salwar Suit")

image_base_path = Rails.root.join("public", "Tailor's Pro")

# label-to-filename mapping
mapping = {
  "Chest/Bust" => "Chest Circumference.png",
  "Waist" => "Waist Circumference.png",
  "Hip" => "Hip Circumference.png",
  "Shoulder Width" => "Shoulder Width.png",
  "Armhole" => "Bicep Circumference.png",
  "Sleeve Length" => "Sleeve Length.png",
  "Sleeve Round" => "Wrist Circumference.png",
  "Kameez Length" => "Kurti Length.png",
  "Front Neck Depth" => "Neck Depth.png",
  "Back Neck Depth" => "Neck Depth.png",
  "Salwar Waist" => "Waist Circumference.png",
  "Salwar Hip" => "Hip Circumference.png",
  "Thigh" => "Thigh Circumference.png",
  "Knee" => "Knee Circumference.png",
  "Calf" => "Calf Circumference.png",
  "Ankle" => "Ankle Circumference.png",
  "Salwar Length" => "Salwar Length.png",
}

garment_type.measurement_fields.each do |field|
  filename = mapping[field.label]
  next unless filename.present?

  path = image_base_path.join(filename)
  unless File.exist?(path)
    puts "❌ Missing image for #{field.label}"
    next
  end

  # remove old image if exists
  field.measurement_image.purge if field.measurement_image.attached?

  # attach new image
  field.measurement_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/png"
  )

  puts "✅ Attached image to #{field.label}"
end

garment_type = GarmentType.find_by(garment_name: "Shirt")

image_base_path = Rails.root.join("public", "Tailor's Pro")

# label-to-filename mapping
mapping = {
  "Neck Round" => "Neck Circumference.png",
  "Shoulder Width" => "Shoulder Width.png",
  "Chest" => "Chest Circumference.png",
  "Waist" => "Waist Circumference.png",
  "Hip" => "Hip Circumference.png",
  "Sleeve Length" => "Sleeve Length.png",
  "Cuff Round" => "Cuff Circumference.png",
  "Shirt Length" => "Shirt Length.png",
}

garment_type.measurement_fields.each do |field|
  filename = mapping[field.label]
  next unless filename.present?

  path = image_base_path.join(filename)
  unless File.exist?(path)
    puts "❌ Missing image for #{field.label}"
    next
  end

  # remove old image if exists
  field.measurement_image.purge if field.measurement_image.attached?

  # attach new image
  field.measurement_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/png"
  )

  puts "✅ Attached image to #{field.label}"
end

garment_type = GarmentType.find_by(garment_name: "Trouser")

image_base_path = Rails.root.join("public", "Tailor's Pro")

# label-to-filename mapping
mapping = {
  "Waist" => "Waist Circumference.png",
  "Hip" => "Hip Circumference.png",
  "Seat" => "Hip Circumference.png",
  "Thigh" => "Thigh Circumference.png",
  "Knee" => "Knee Circumference.png",
  "Calf" => "Calf Circumference.png",
  "Ankle" => "Ankle Circumference.png",
  "Trouser Length" => "Trouser Length.png",
  "Inseam Length" => "Inseam Length.png",
}

garment_type.measurement_fields.each do |field|
  filename = mapping[field.label]
  next unless filename.present?

  path = image_base_path.join(filename)
  unless File.exist?(path)
    puts "❌ Missing image for #{field.label}"
    next
  end

  # remove old image if exists
  field.measurement_image.purge if field.measurement_image.attached?

  # attach new image
  field.measurement_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/png"
  )

  puts "✅ Attached image to #{field.label}"
end

garment_type = GarmentType.find_by(garment_name: "Kurta")

image_base_path = Rails.root.join("public", "Tailor's Pro")

# label-to-filename mapping
mapping = {
  "Chest/Bust" => "Chest Circumference.png",
  "Waist" => "Waist Circumference.png",
  "Hip" => "Hip Circumference.png",
  "Shoulder Width" => "Shoulder Width.png",
  "Armhole" => "Bicep Circumference.png",
  "Sleeve Length" => "Sleeve Length.png",
  "Sleeve Round" => "Wrist Circumference.png",
  "Kurta Length" => "Kurta Length.png",
  "Front Neck Depth" => "Neck Depth.png",
  "Back Neck Depth" => "Neck Depth.png"
}

garment_type.measurement_fields.each do |field|
  filename = mapping[field.label]
  next unless filename.present?

  path = image_base_path.join(filename)
  unless File.exist?(path)
    puts "❌ Missing image for #{field.label}"
    next
  end

  # remove old image if exists
  field.measurement_image.purge if field.measurement_image.attached?

  # attach new image
  field.measurement_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/png"
  )

  puts "✅ Attached image to #{field.label}"
end

garment_type = GarmentType.find_by(garment_name: "Sherwani")

image_base_path = Rails.root.join("public", "Tailor's Pro")

# label-to-filename mapping
mapping = {
  "Chest/Bust" => "Chest Circumference.png",
  "Waist" => "Waist Circumference.png",
  "Hip" => "Hip Circumference.png",
  "Shoulder Width" => "Shoulder Width.png",
  "Armhole" => "Bicep Circumference.png",
  "Sleeve Length" => "Sleeve Length.png",
  "Sleeve Round" => "Wrist Circumference.png",
  "Sherwani Length" => "Sherwani Length.png",
  "Front Neck Depth" => "Neck Depth.png",
  "Back Neck Depth" => "Neck Depth.png"
}

garment_type.measurement_fields.each do |field|
  filename = mapping[field.label]
  next unless filename.present?

  path = image_base_path.join(filename)
  unless File.exist?(path)
    puts "❌ Missing image for #{field.label}"
    next
  end

  # remove old image if exists
  field.measurement_image.purge if field.measurement_image.attached?

  # attach new image
  field.measurement_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/png"
  )

  puts "✅ Attached image to #{field.label}"
end

garment_type = GarmentType.find_by(garment_name: "Coat")

image_base_path = Rails.root.join("public", "Tailor's Pro")

# label-to-filename mapping
mapping = {
  "Chest/Bust" => "Chest Circumference.png",
  "Shoulder Width" => "Shoulder Width.png",
  "Sleeve Length" => "Sleeve Length.png",
  "Sleeve Round" => "Wrist Circumference.png",
  "Coat Length" => "Shirt Length.png",
}


garment_type.measurement_fields.each do |field|
  filename = mapping[field.label]
  next unless filename.present?

  path = image_base_path.join(filename)
  unless File.exist?(path)
    puts "❌ Missing image for #{field.label}"
    next
  end

  # remove old image if exists
  field.measurement_image.purge if field.measurement_image.attached?

  # attach new image
  field.measurement_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/png"
  )

  puts "✅ Attached image to #{field.label}"
end




puts "✅ Measurement fields created with garment_type_id reference."
puts "✅ Seeding completed."

# store = Store.find(415)
# customer = Customer.find(124)

# puts "🧵 Seeding test orders for Store ##{store.id} (Customer ##{customer.id})"

# --- Helper method for creating fake orders ---
# def create_fake_orders(store:, customer:, start_date:, end_date:)
#   puts "📅 Creating orders from #{start_date} → #{end_date}"

#   (start_date..end_date).each do |date|
#     next if rand > 0.5
#     1.times do
#       total = rand(500..1000)
#       received = total * rand(0.7..1.0)
#       balance = total - received

#       order = Order.new(
#         store_id: store.id,
#         customer_id: customer.id,
#         order_number: SecureRandom.hex(4).upcase,
#         status: "accepted",
#         total_bill_amount: total,
#         payment_received: received,
#         balance_due: balance,
#         discount: rand(0..100),
#         courier_to_customer: false,
#         order_date: date,
#         created_at: date,
#         updated_at: date,
#       )

#       order.save!(validate: false)

#       # Add order items
#       rand(1..2).times do
#         order.order_items.create!(
#           name: ["Shirt", "Pant", "Kurta", "Blouse", "Jacket"].sample,
#           work_type: %w[stitching alteration].sample,
#           quantity: rand(1..3),
#           price: rand(200..800),
#           delivery_date: date + rand(2..6).days,
#           garment_type_id: GarmentType.pluck(:id).sample,
#           stichfor: %w[male female].sample,
#         )
#       end
#     end
#   end

#   puts "✅ Created #{Order.where(order_date: start_date..end_date, store_id: store.id).count} orders for #{start_date.strftime("%B %Y")}"
# end

# # --- 🗓️ 1️⃣ Create Data for Last Financial Year (Apr 2024 – Mar 2025) ---
# fy_start = Date.new(2024, 4, 1)
# fy_end = Date.new(2025, 3, 31)
# puts "🏦 Seeding data for last financial year: #{fy_start} → #{fy_end}"

# (fy_start..fy_end).group_by { |d| [d.year, d.month] }.each do |(_year, _month), days|
#   start_date = days.first
#   end_date = days.last
#   create_fake_orders(store: store, customer: customer, start_date: start_date, end_date: end_date)
# end

# # --- 2️⃣ Last 6 months (daily data) ---
# 6.times do |i|
#   month = Date.today << (i + 1)
#   start_date = month.beginning_of_month
#   end_date = month.end_of_month
#   create_fake_orders(store: store, customer: customer, start_date: start_date, end_date: end_date)
# end

# # --- 3️⃣ Last month ---
# last_month = Date.today.prev_month
# last_month_start = last_month.beginning_of_month
# last_month_end = last_month.end_of_month
# create_fake_orders(store: store, customer: customer, start_date: last_month_start, end_date: last_month_end)

# # --- 4️⃣ Last week ---
# last_week_start = 1.week.ago.beginning_of_week.to_date
# last_week_end = 1.week.ago.end_of_week.to_date
# create_fake_orders(store: store, customer: customer, start_date: last_week_start, end_date: last_week_end)

# # --- 5️⃣ This month (dynamic current month) ---
# this_month_start = Date.today.beginning_of_month
# this_month_end = Date.today.end_of_month
# create_fake_orders(store: store, customer: customer, start_date: this_month_start, end_date: this_month_end)

# # --- 🔄 Update totals for all seeded ranges ---
# all_ranges = []

# # Financial year
# all_ranges << (fy_start..fy_end)

# # Last 6 months, last month, last week, this month
# 6.times do |i|
#   m = Date.today << (i + 1)
#   all_ranges << (m.beginning_of_month..m.end_of_month)
# end
# all_ranges << (last_month_start..last_month_end)
# all_ranges << (last_week_start..last_week_end)
# all_ranges << (this_month_start..this_month_end)

# Order.where(order_date: all_ranges, store_id: store.id).find_each do |order|
#   total = rand(500..2000)
#   received = total * rand(0.7..1.0)
#   balance = total - received

#   order.update_columns(
#     total_bill_amount: total.round(2),
#     payment_received: received.round(2),
#     balance_due: balance.round(2),
#     updated_at: order.order_date,
#   )
# end

# puts "💰 Updated all seeded orders with realistic totals!"
# puts "🎉 Test data seeding complete for last financial year, last 6 months, last month, last week, and this month!"
