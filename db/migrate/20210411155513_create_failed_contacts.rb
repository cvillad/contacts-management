class CreateFailedContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :failed_contacts do |t|
      t.string :name
      t.string :address
      t.string :email
      t.string :birth_date
      t.string :phone
      t.string :card_number
      t.text :error_details, array: true, default: []
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
