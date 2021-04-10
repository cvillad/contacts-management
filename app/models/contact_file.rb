class ContactFile < ApplicationRecord
  belongs_to :user
  before_save -> {
    self.name = csv_file.blob.filename
    self.headers = csv_headers
  }
  has_one_attached :csv_file, dependent: :destroy
  validates :csv_file, attached: true, content_type: ["text/csv"]

  def csv_headers
    CSV.open(csv_path, &:readline)
  end

  def csv_path
    ActiveStorage::Blob.service.send(:path_for, csv_file.key)
  end

  def import(user, map_headers)
    CSV.foreach(csv_path, headers: true) do |row|
      contact = user.contacts.build(
        email: row[map_headers[:email]],
        name: row[map_headers[:name]],
        birth_date: row[map_headers[:birth_date]],
        phone: row[map_headers[:phone]],
        address: row[map_headers[:address]],
        card_number: row[map_headers[:card_number]]
      )
      contact.save
    end
  end
end
