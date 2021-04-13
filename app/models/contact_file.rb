class ContactFile < ApplicationRecord
  belongs_to :user

  enum status: {waiting: 0, processing: 1, failed: 2, finished: 3}
  attr_accessor :failed_contacts_count, :success_contacts_count

  has_one_attached :csv_file, dependent: :destroy
  has_many :failed_contacts

  validates :headers, presence: {message: "CSV file can't be blank"}
  validates :csv_file, attached: true, content_type: ["text/csv"]

  def import(map_headers)
    success = false
    map_headers.symbolize_keys!
    table = CSV.parse(csv_file.download, headers:  true)
    table.each do |row|
      contact = user.contacts.build(
        email: row[map_headers[:email]],
        name: row[map_headers[:name]],
        birth_date: row[map_headers[:birth_date]],
        phone: row[map_headers[:phone]],
        address: row[map_headers[:address]],
        card_number: row[map_headers[:card_number]]
      )
      if contact.save
        success = true
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
    success ? self.finished! : self.failed!
  end
end
