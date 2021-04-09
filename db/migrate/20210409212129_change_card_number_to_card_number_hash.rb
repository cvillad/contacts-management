class ChangeCardNumberToCardNumberHash < ActiveRecord::Migration[6.1]
  change_table :contacts do |t|
    t.rename :card_number, :card_number_hash
  end
end
