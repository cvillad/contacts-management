class AddMatchedHeadersToContactFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :contact_files, :matched_headers, :text
  end
end
