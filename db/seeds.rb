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

puts "SEEDING ACCESSORY CATEGORIES "

puts "🧵 Seeding ALL Categories + Accessories..."

data = [

  # --- Categories WITH accessories ---
  {
    name: "Zippers",
    items: ["Closed-End", "Open-End", "Invisible", "Metal", "Coil (Plastic)", "Two-Way"],
  },
  {
    name: "Needles",
    items: ["Ballpoint Needle", "Denim Needle", "Embroidery Needle", "Leather Needle", "Twin Needle"],
  },
  {
    name: "Elastics",
    items: ["Knitted Elastic", "Woven Elastic", "Braided Elastic", "Buttonhole Elastic", "Fold-Over Elastic"],
  },
  {
    name: "Measuring tape",
    items: ["Dual-Sided Tape", "Body Measuring Tape"],
  },
  {
    name: "Thread",
    items: ["Polyester Thread", "Cotton Thread", "Silk Thread", "Embroidery Thread", "Overlock Thread"],
  },
  {
    name: "Machine Types",
    items: ["Single Needle Machine", "Overlock Machine", "Zigzag Machine", "Hand Stitch Machine"],
  },
  {
    name: "Dye Types",
    items: ["Piece Dyeing", "Yarn Dyeing", "Garment Dyeing", "Tie-Dye", "Dip Dye"],
  },
]

data.each_with_index do |category_data, index|
  category = AccessoryCategory.find_or_initialize_by(name: category_data[:name])

  category.update!(
    position: index + 1,
    is_active: category_data[:items].present?,
  )

  category_data[:items].each_with_index do |item, idx|
    accessory = Accessory.find_or_initialize_by(
      name: item,
      accessory_category_id: category.id,
    )

    accessory.update!(
      position: idx + 1,
      is_active: true,
    )
  end
end

puts "✅ All categories seeded properly!"
