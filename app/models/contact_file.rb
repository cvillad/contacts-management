class ContactFile < ApplicationRecord
  belongs_to :user
  before_save -> {
    self.name = csv_file.blob.filename
    self.headers = csv_headers
  }

  has_one_attached :csv_file, dependent: :destroy
  has_many :failed_contacts

  validates :csv_file, attached: true, content_type: ["text/csv"]

  def csv_headers
    CSV.open(csv_path, headers: true).read.headers
  end

  def csv_path
    ActiveStorage::Blob.service.send(:path_for, csv_file.key)
  end

  def import(map_headers)
    CSV.foreach(csv_path, headers: true) do |row|
      contact = user.contacts.build(
        email: row[map_headers[:email]],
        name: row[map_headers[:name]],
        birth_date: row[map_headers[:birth_date]],
        phone: row[map_headers[:phone]],
        address: row[map_headers[:address]],
        card_number: row[map_headers[:card_number]]
      )
      if contact.save
      else
        user.failed_contacts.create(
          email: row[map_headers[:email]],
          name: row[map_headers[:name]],
          birth_date: row[map_headers[:birth_date]],
          phone: row[map_headers[:phone]],
          address: row[map_headers[:address]],
          card_number: row[map_headers[:card_number]],
          error_details: contact.errors.full_messages
        )
      end
    end
  end
end
