# Create default role super admin and assign to first admin user
super_admin_role = Role.find_or_create_by!(name: "super_admin") do |r|
  r.display_name = "Super Admin"
  r.is_super_admin = true
end

if Rails.env.development?
  AdminUser.find_or_create_by!(email: "admin@example.com") do |admin|
    admin.password = "password"
    admin.password_confirmation = "password"
    admin.role_id = super_admin_role.id
  end
else
  AdminUser.find_or_create_by!(email: "adminpro@example.com") do |admin|
    admin.password = "password"
    admin.password_confirmation = "password"
    admin.role_id = super_admin_role.id
  end
end

puts "Cleaning up existing data..."

puts "Starting seeding process..."

# Master Data Dictionary reflecting the mixed hierarchy
master_data = {
  "Fabrics" => {
    has_subcategories: true,
    items: {
      "Cotton" => ["Pure cotton", "Poplin", "Cambric", "Twill cotton"],
      "Linen" => ["Pure linen", "Linen blends"],
      "Silk" => ["Pure Silk", "Raw silk", "Banarasi silk", "Gajji silk"],
      "Woolen" => ["Tweed", "Merino wool", "Wool blends"],
      "Denim" => [],
      "Polyester" => ["Poly-cotton"],
      "Rayon" => ["Modal"],
      "Khadi" => ["Handwoven cotton"],
      "Velvet" => [],
      "Cotton Silk" => [],
      "Satin" => [],
      "Chiffon" => [],
      "Georgette" => [],
      "Net/Tulle" => [],
    },
  },
  "Accessories" => {
    has_subcategories: true,
    items: {
      "Measuring tape" => ["Dual-Sided Tape", "Body Measuring Tape"],
      "Rulers, scale" => [],
      "French curve" => [],
      "Scissors" => [],
      "Thread cutters" => ["Spring thread snips", "Electric thread cutter"],
      "Rotary cutters" => [],
      "Tracing wheel" => [],
      "Needles" => ["Ballpoint Needle", "Denim Needle", "Embroidery Needle", "Leather Needle", "Twin Needle"],
      "Zippers" => ["Closed-End", "Open-End", "Invisible", "Metal", "Coil (Plastic)", "Two-Way"],
      "Hooks" => [],
      "Velcro" => ["Industrial Velcro", "Self-adhesive Velcro"],
      "Elastics" => ["Knitted Elastic", "Woven Elastic", "Braided Elastic", "Buttonhole Elastic", "Fold-Over Elastic"],
    },
  },
  "Stitching Machines" => {
    has_subcategories: false,
    items: [
      "Single Needle", "Double Needle", "Overlock", "Flatlock",
      "Zigzag", "Button Hole", "Bartack", "Feed of arm", "Embroidery",
    ],
  },
  "Threads" => {
    has_subcategories: false,
    items: [
      "Cotton Threads", "Polyester Thread", "Silk Thread",
      "Nylon Thread", "Embroidery Thread", "Elastic Thread",
      "Metallic Thread", "Woolen Yarn", "Overlock Thread",
    ],
  },
  "Dyes & Chemicals" => {
    has_subcategories: false,
    items: [
      "Piece Dyeing", "Yarn Dyeing", "Garment Dyeing", "Tie-Dye", "Dip Dye",
    ],
  },
}

puts "Cleaning up existing data..."
puts "Starting seeding process..."

ActiveRecord::Base.transaction do
  parent_position = 1

  master_data.each do |parent_name, data|
    # 1. Parent Category (find or create)
    parent_category = StitchIt::Category.find_or_initialize_by(name: parent_name)
    parent_category.assign_attributes(
      is_active: true,
      position: parent_position,
      parent_id: nil,
    )
    parent_category.save!

    puts "Created/Found Parent Category: #{parent_category.name}"

    if data[:has_subcategories]
      # --- 3-LEVEL HIERARCHY ---
      sub_position = 1

      data[:items].each do |sub_name, products|
        sub_category = StitchIt::Category.find_or_initialize_by(
          name: sub_name,
          parent_id: parent_category.id,
        )
        sub_category.assign_attributes(
          is_active: true,
          position: sub_position,
        )
        sub_category.save!

        product_position = 1

        products.each do |product_name|
          product = StitchIt::Product.find_or_initialize_by(
            name: product_name,
            category_id: sub_category.id,
          )
          product.assign_attributes(
            is_active: true,
            position: product_position,
          )
          product.save!

          product_position += 1
        end

        sub_position += 1
      end
    else
      # --- 2-LEVEL HIERARCHY ---
      product_position = 1

      data[:items].each do |product_name|
        product = StitchIt::Product.find_or_initialize_by(
          name: product_name,
          category_id: parent_category.id,
        )
        product.assign_attributes(
          is_active: true,
          position: product_position,
        )
        product.save!

        product_position += 1
      end
    end

    parent_position += 1
  end
end

puts "================================================="
puts "Seeding complete!"
puts "Total Parent Categories: #{StitchIt::Category.where(parent_id: nil).count}"
puts "Total Sub-Categories: #{StitchIt::Category.where.not(parent_id: nil).count}"
puts "Total Products: #{StitchIt::Product.count}"
puts "================================================="

puts "🧵 Seeding StitchIt::GarmentType..."

male_garments = ["Shirt", "Trouser", "Kurta", "Sherwani", "Coat"]
female_garments = ["Blouse", "Dress", "Kurti", "Lehenga", "Salwar Suit"]

male_garments.each do |name|
  StitchIt::GarmentType.find_or_create_by!(name: name, gender: 0) do |gt|
    gt.active = true
    gt.category_type = 0 # single
    gt.parent_id = nil
  end
  puts "#{name}"
end

female_garments.each do |name|
  StitchIt::GarmentType.find_or_create_by!(name: name, gender: 1) do |gt|
    gt.active = true
    gt.category_type = 0 # single
    gt.parent_id = nil
  end
  puts "#{name}"
end

puts "StitchIt::GarmentType seeding complete!"

# -------------------------------------------------------------------
# StitchIt::MeasurementField — global shared fields
# -------------------------------------------------------------------

puts "\n📐 Seeding StitchIt::MeasurementField..."

all_measurement_labels = [
  "Chest/Bust", "Underbust", "Waist", "Hip", "Seat",
  "Shoulder Width", "Armhole", "Neck Round",
  "Sleeve Length", "Sleeve Round", "Cuff Round",
  "Shirt Length", "Blouse Length", "Kurti Length", "Kurta Length",
  "Sherwani Length", "Coat Length", "Dress Length", "Kameez Length",
  "Lehenga Length", "Trouser Length", "Salwar Length", "Inseam Length",
  "Front Neck Depth", "Back Neck Depth",
  "Thigh", "Knee", "Calf", "Ankle",
  "Salwar Waist", "Salwar Hip",
  "Bottom Bells / Hem Width",
]

all_measurement_labels.each_with_index do |label, index|
  StitchIt::MeasurementField.find_or_create_by!(label: label) do |f|
    f.field_key = label.downcase.gsub(/[\s\/]+/, "_").gsub(/[^a-z0-9_]/, "")
    f.position = index + 1
    f.active = true
  end
  puts "#{label}"
end

puts "StitchIt::MeasurementField seeding complete!"

# -------------------------------------------------------------------
# StitchIt::GarmentTypeMeasurement — join table
# -------------------------------------------------------------------

puts "\n🔗 Seeding StitchIt::GarmentTypeMeasurement..."

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
    "Neck Round", "Shoulder Width", "Chest/Bust", "Waist",
    "Hip", "Sleeve Length", "Cuff Round", "Shirt Length",
  ],
  "Trouser" => [
    "Waist", "Hip", "Seat", "Thigh", "Knee", "Calf", "Ankle",
    "Trouser Length", "Inseam Length",
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

measurement_mappings.each do |garment_name, labels|
  garment = StitchIt::GarmentType.find_by(name: garment_name)
  unless garment
    puts "StitchIt::GarmentType not found: #{garment_name}, skipping..."
    next
  end

  labels.each do |label|
    field = StitchIt::MeasurementField.find_by(label: label)
    unless field
      puts "StitchIt::MeasurementField not found: #{label}, skipping..."
      next
    end

    StitchIt::GarmentTypeMeasurement.find_or_create_by!(
      garment_type_id: garment.id,
      measurement_field_id: field.id,
    )
  end

  puts "Linked #{labels.size} fields to #{garment_name}"
end

puts "\n StitchIt measurement seeding complete!"

# -------------------------------------------------------------------
# Notification Templates
# -------------------------------------------------------------------

notification_templates = [
  {
    key: "order_assigned",
    title: "New Order Assigned",
    body: "Order #%{order_number} has been assigned to you. Have a good day.",
    active: true,
  },
  {
    key: "stitch_it_inquiry",
    title: "New Inquiry Received",
    body: "A new %{garment_type} inquiry has been received at %{store_name}. It's just %{distance} km away from your location. Check it out now!",
    active: true,
  },
]

notification_templates.each do |attrs|
  NotificationTemplate.find_or_create_by!(key: attrs[:key]) do |template|
    template.title = attrs[:title]
    template.body = attrs[:body]
    template.active = attrs[:active]
  end
end

puts "Seed: Notification templates processed."
