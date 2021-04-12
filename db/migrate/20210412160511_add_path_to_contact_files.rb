class AddPathToContactFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :contact_files, :path, :string
  end
end
