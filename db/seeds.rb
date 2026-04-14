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

# ---------------------------------------------------------------------------
# Auto-detect image root
# ---------------------------------------------------------------------------
def stitch_it_find_image_root
  candidates = [
    Rails.root.join("app", "assets", "images"),
    Rails.root.parent.join("tailor-pro-admin", "app", "assets", "images"),
    Rails.root.parent.join("tailor_pro_admin", "app", "assets", "images"),
    Pathname.new("/home/developer/Desktop/Nisha/tailor-pro-admin/app/assets/images"),
  ]

  candidates.each do |root|
    next unless root.exist?
    return root if root.join("Items (female)").exist? ||
                   root.join("Items (male)").exist? ||
                   root.join("Tailor's Pro").exist?
  end

  Rails.root.join("app", "assets", "images")
end

IMAGE_ROOT = stitch_it_find_image_root
FEMALE_FOLDER = IMAGE_ROOT.join("Items (female)")
MALE_FOLDER = IMAGE_ROOT.join("Items (male)")
MEASUREMENT_FOLDER = IMAGE_ROOT.join("Tailor's Pro")

puts "📁 Image root : #{IMAGE_ROOT}"
puts "  Female      : #{FEMALE_FOLDER.exist? ? "✔" : "⚠️  MISSING"}"
puts "  Male        : #{MALE_FOLDER.exist? ? "✔" : "⚠️  MISSING"}"
puts "  Measurement : #{MEASUREMENT_FOLDER.exist? ? "✔" : "⚠️  MISSING"}"

# ---------------------------------------------------------------------------
# Helper — attach image via Active Storage (idempotent)
# ---------------------------------------------------------------------------
def attach_image(record, local_path, filename)
  local_path = Pathname.new(local_path.to_s)

  unless local_path.exist?
    puts "  ⚠️  Not found: #{filename}"
    return
  end

  record.image.attach(
    io: File.open(local_path),
    filename: filename,
    content_type: "image/png",
  )
  puts "  ✅ Attached: #{filename}"
rescue => e
  puts "  ❌ Failed [#{filename}]: #{e.message}"
end

# ---------------------------------------------------------------------------
# Garment types data
# name, gender, file (inside Items (female)/ or Items (male)/)
# ---------------------------------------------------------------------------
STITCH_IT_GARMENTS = [
  # Female
  { name: "Blouse", gender: "female", file: "Blouse.png" },
  { name: "Dress", gender: "female", file: "Dress.png" },
  { name: "Kurti", gender: "female", file: "Kurti.png" },
  { name: "Lehenga", gender: "female", file: "Lehenga.png" },
  { name: "Salwar Suit", gender: "female", file: "Salwar Suit.png" },
  # Male
  { name: "Shirt", gender: "male", file: "Shirt.png" },
  { name: "Trouser", gender: "male", file: "Trouser.png" },
  { name: "Kurta", gender: "male", file: "Kurta.png" },
  { name: "Sherwani", gender: "male", file: "Shervani.png" },
  { name: "Coat", gender: "male", file: "Coat.png" },
].freeze

# ---------------------------------------------------------------------------
# Measurement fields data
# label => { key:, position:, image_file: (inside Tailor's Pro/) }
# All filenames confirmed from VSCode screenshots.
# ---------------------------------------------------------------------------
STITCH_IT_MEASUREMENT_FIELDS = {
  # Circumference / width
  "Shoulder" => { key: "shoulder", position: 1, image_file: "Shoulder Width.png" },
  "Chest" => { key: "chest", position: 2, image_file: "Chest Circumference.png" },
  "Under Bust" => { key: "under_bust", position: 3, image_file: "Lower Bust Circumference.png" },
  "Upper Bust" => { key: "upper_bust", position: 4, image_file: "Chest Circumference.png" },
  "Waist" => { key: "waist", position: 5, image_file: "Waist Circumference.png" },
  "Seat / Hip" => { key: "seat_hip", position: 6, image_file: "Hip Circumference.png" },
  "Armhole" => { key: "armhole", position: 7, image_file: "Scye.png" },
  "Bicep" => { key: "bicep", position: 8, image_file: "Bicep Circumference.png" },
  "Elbow" => { key: "elbow", position: 9, image_file: "Elbow Circumference.png" },
  "Sleeve Round" => { key: "sleeve_round", position: 10, image_file: "Wrist Circumference.png" },
  "Wrist / Cuff" => { key: "wrist_cuff", position: 11, image_file: "Cuff Circumference.png" },
  "Neck" => { key: "neck", position: 12, image_file: "Neck Circumference.png" },
  "Neck Width" => { key: "neck_width", position: 13, image_file: "Neck Circumference.png" },
  "Front Neck Depth" => { key: "front_neck_depth", position: 14, image_file: "Neck Depth.png" },
  "Back Neck Depth" => { key: "back_neck_depth", position: 15, image_file: "Neck Depth.png" },
  # Lengths
  "Sleeve" => { key: "sleeve", position: 16, image_file: "Sleeve Length.png" },
  "Blouse Length" => { key: "blouse_length", position: 17, image_file: "Blouse Length.png" },
  "Kurti Length" => { key: "kurti_length", position: 18, image_file: "Kurti Length.png" },
  "Kurta Length" => { key: "kurta_length", position: 19, image_file: "Kurta Length.png" },
  "Kameez Length" => { key: "kameez_length", position: 20, image_file: "Kameez Length.png" },
  "Sherwani Length" => { key: "sherwani_length", position: 21, image_file: "Sherwani Length.png" },
  "Shirt Length" => { key: "shirt_length", position: 22, image_file: "Shirt Length.png" },
  "Length" => { key: "length", position: 23, image_file: "Pent Length.png" },
  "Pant Length" => { key: "pant_length", position: 24, image_file: "Pent Length.png" },
  "Trouser Length" => { key: "trouser_length", position: 25, image_file: "Trouser Length.png" },
  "Inseam" => { key: "inseam", position: 26, image_file: "Inseam Length.png" },
  "Salwar Length" => { key: "salwar_length", position: 27, image_file: "Salwar Length.png" },
  # Lower body
  "Thigh" => { key: "thigh", position: 28, image_file: "Thigh Circumference.png" },
  "Knee" => { key: "knee", position: 29, image_file: "Knee Circumference.png" },
  "Bottom" => { key: "bottom", position: 30, image_file: "Calf Circumference.png" },
  "Calf" => { key: "calf", position: 31, image_file: "Calf Circumference.png" },
  "Ankle" => { key: "ankle", position: 32, image_file: "Ankle Circumference.png" },
  # Lehenga
  "Flare / Gher" => { key: "flare_gher", position: 33, image_file: "Lahenga Length.png" },
}.freeze

# ---------------------------------------------------------------------------
# Garment → measurement field mappings
# ---------------------------------------------------------------------------
STITCH_IT_GARMENT_MEASUREMENTS = {
  "Blouse" => [
    "Shoulder", "Chest", "Under Bust", "Upper Bust", "Waist",
    "Armhole", "Sleeve", "Sleeve Round",
    "Blouse Length", "Front Neck Depth", "Back Neck Depth", "Neck Width",
  ],
  "Dress" => [
    "Shoulder", "Chest", "Waist", "Seat / Hip", "Armhole",
    "Sleeve", "Sleeve Round", "Length",
    "Front Neck Depth", "Back Neck Depth",
  ],
  "Kurti" => [
    "Shoulder", "Chest", "Waist", "Seat / Hip", "Armhole",
    "Sleeve", "Sleeve Round", "Bicep", "Wrist / Cuff",
    "Kurti Length", "Front Neck Depth", "Back Neck Depth", "Neck Width",
  ],
  "Lehenga" => [
    "Waist", "Seat / Hip", "Length", "Flare / Gher",
  ],
  "Salwar Suit" => [
    "Shoulder", "Chest", "Waist", "Seat / Hip", "Armhole",
    "Sleeve", "Sleeve Round", "Wrist / Cuff",
    "Front Neck Depth", "Back Neck Depth", "Neck Width",
    "Kameez Length", "Thigh", "Knee", "Bottom", "Salwar Length",
  ],
  "Shirt" => [
    "Neck", "Shoulder", "Chest", "Waist", "Seat / Hip",
    "Sleeve", "Sleeve Round", "Bicep", "Wrist / Cuff",
    "Length", "Armhole",
  ],
  "Trouser" => [
    "Waist", "Seat / Hip", "Trouser Length", "Thigh",
    "Knee", "Bottom", "Calf", "Inseam",
  ],
  "Kurta" => [
    "Neck", "Shoulder", "Chest", "Waist", "Seat / Hip",
    "Sleeve", "Sleeve Round", "Bicep", "Wrist / Cuff",
    "Armhole", "Kurta Length",
    "Front Neck Depth", "Back Neck Depth",
  ],
  "Sherwani" => [
    "Neck", "Shoulder", "Chest", "Waist", "Seat / Hip",
    "Sleeve", "Sleeve Round", "Bicep", "Wrist / Cuff",
    "Armhole", "Sherwani Length",
    "Front Neck Depth", "Back Neck Depth",
  ],
  "Coat" => [
    "Neck", "Shoulder", "Chest", "Waist", "Seat / Hip",
    "Sleeve", "Armhole",
  ],
}.freeze

# ===========================================================================
# EXECUTION
# ===========================================================================
puts "\n" + "=" * 70
puts "🧵 StitchIt — Seeding with Active Storage"
puts "=" * 70

ActiveRecord::Base.transaction do

  # -------------------------------------------------------------------------
  # 1. Garment Types
  # -------------------------------------------------------------------------
  puts "\n👗 Seeding StitchIt::GarmentType …"

  garment_records = {}

  STITCH_IT_GARMENTS.each do |g|
    garment = StitchIt::GarmentType.find_or_initialize_by(
      name: g[:name],
      gender: g[:gender],
    )

    garment.active = true
    garment.category_type = "single"
    garment.parent_id = nil
    garment.save!

    # Attach image via Active Storage only if not already attached
    unless garment.image.attached?
      folder = g[:gender] == "female" ? FEMALE_FOLDER : MALE_FOLDER
      attach_image(garment, folder.join(g[:file]), g[:file])
    else
      puts "  ⏭  #{g[:name]} — image already attached"
    end

    garment_records[g[:name]] = garment
    puts "  ✔ #{g[:gender].capitalize} — #{g[:name]} (id: #{garment.id})"
  end

  # -------------------------------------------------------------------------
  # 2. Measurement Fields
  # -------------------------------------------------------------------------
  puts "\n📐 Seeding StitchIt::MeasurementField …"

  field_records = {}

  STITCH_IT_MEASUREMENT_FIELDS.each do |label, meta|
    field = StitchIt::MeasurementField.find_or_initialize_by(label: label)

    field.field_key = meta[:key]
    field.position = meta[:position]
    field.active = true
    field.save!

    # Attach image via Active Storage only if not already attached
    unless field.image.attached?
      attach_image(field, MEASUREMENT_FOLDER.join(meta[:image_file]), meta[:image_file])
    else
      puts "  ⏭  #{label} — image already attached"
    end

    field_records[label] = field
    puts "  ✔ [#{meta[:position].to_s.rjust(2)}] #{label}"
  end

  # -------------------------------------------------------------------------
  # 3. GarmentTypeMeasurement join table
  # -------------------------------------------------------------------------
  puts "\n🔗 Seeding StitchIt::GarmentTypeMeasurement …"

  STITCH_IT_GARMENT_MEASUREMENTS.each do |garment_name, labels|
    garment = garment_records[garment_name]
    unless garment
      puts "  ⚠️  GarmentType not found: #{garment_name} — skipping"
      next
    end

    labels.each do |label|
      field = field_records[label]
      unless field
        puts "  ⚠️  MeasurementField '#{label}' not found for #{garment_name} — skipping"
        next
      end

      StitchIt::GarmentTypeMeasurement.find_or_create_by!(
        garment_type_id: garment.id,
        measurement_field_id: field.id,
      )
    end

    puts "  ✔ #{garment_name} → #{labels.size} fields linked"
  end
end # transaction

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
puts "\n" + "=" * 70
puts "✅ StitchIt seeding complete!"
puts "   GarmentTypes            : #{StitchIt::GarmentType.count}"
puts "   MeasurementFields       : #{StitchIt::MeasurementField.count}"
puts "   GarmentTypeMeasurements : #{StitchIt::GarmentTypeMeasurement.count}"
puts "=" * 70
