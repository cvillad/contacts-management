class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.date :born_date
      t.string :phone
      t.string :address
      t.string :card_number
      t.string :card_franchise
      t.string :email

      t.timestamps
    end
    add_index :contacts, :email, unique: true
  end
end
