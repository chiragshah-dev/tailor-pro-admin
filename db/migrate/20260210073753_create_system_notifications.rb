class CreateSystemNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :system_notifications do |t|
      t.string :title
      t.text :message
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
