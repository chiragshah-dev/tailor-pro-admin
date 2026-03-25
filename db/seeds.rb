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

# ============================================================
# Accessory Categories & Accessories Seed
# ============================================================

puts "Seeding Accessory Categories and Accessories..."

# ============================================================
# CATEGORIES WITH THEIR ACCESSORIES
# ============================================================

categories_data = [
  {
    name: "Fabrics",
    position: 1,
    accessories: [
      "Cotton", "Gaji Silk", "Cotton Silk", "Satin", "Linen",
      "Denim", "Chiffon", "Velvet", "Georgette", "Rayon",
      "Net/Tulle", "Woolen",
    ],
  },
  {
    name: "Accessories",
    position: 2,
    accessories: [],
  },
  {
    name: "Stitching Machines",
    position: 3,
    accessories: [
      "Single Needle", "Double Needle", "Overlock",
      "Flatlock", "Zigzag", "Button Hole", "Bartack",
      "Feed of Arm", "Embroidery",
    ],
  },
  {
    name: "Threads",
    position: 4,
    accessories: [
      # Thread Types
      "Polyester Thread", "Cotton Thread", "Silk Thread",
      "Embroidery Thread", "Overlock Thread",
      # From image 2
      "Cotton Threads", "Polyester Thread", "Nylon Thread",
      "Embroidery Thread", "Elastic Thread", "Metallic Thread", "Woolen Yarn",
    ].uniq,
  },
  {
    name: "Dyes & Chemicals",
    position: 5,
    accessories: [
      "Piece Dyeing", "Yarn Dyeing", "Garment Dyeing",
      "Tie-Dye", "Dip Dye",
    ],
  },
]

categories_data.each do |cat_data|
  category = AccessoryCategory.find_or_initialize_by(name: cat_data[:name])
  category.assign_attributes(
    position: cat_data[:position],
    is_active: true,
  )
  category.save!
  puts "Category: #{category.name}"

  cat_data[:accessories].each_with_index do |acc_name, index|
    accessory = category.accessories.find_or_initialize_by(name: acc_name)
    accessory.assign_attributes(
      position: index + 1,
      is_active: true,
    )
    accessory.save!
    puts "      → #{acc_name}"
  end
end

puts "\n✅ Done! Seeded #{AccessoryCategory.count} categories and #{Accessory.count} accessories."
