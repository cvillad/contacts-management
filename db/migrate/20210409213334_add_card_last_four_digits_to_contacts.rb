class AddCardLastFourDigitsToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :card_last_four_digits, :string
  end
end
