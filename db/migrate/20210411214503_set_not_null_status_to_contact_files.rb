class SetNotNullStatusToContactFiles < ActiveRecord::Migration[6.1]
  def up
    change_column :contact_files, :status, :integer, default: 0
  end

  def down
    change_column :contact_files, :status, :integer
  end
end
