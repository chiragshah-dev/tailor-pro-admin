class CreateRole < ActiveRecord::Migration[8.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :display_name, null: false
      t.boolean :is_super_admin, default: false, null: false

      t.timestamps
    end
    add_index :roles, :name, unique: true
  end
end
