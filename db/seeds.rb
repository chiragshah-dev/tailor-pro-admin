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
