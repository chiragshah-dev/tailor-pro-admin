class CreateNotificationTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :notification_templates do |t|
      t.string :key
      t.string :title
      t.text :body
      t.boolean :active

      t.timestamps
    end
  end
end
