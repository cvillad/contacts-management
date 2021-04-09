class CreateContactFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_files do |t|
      t.string :name
      t.text :headers, array: true
      t.references :user, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
