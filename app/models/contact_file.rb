class ContactFile < ApplicationRecord
  belongs_to :user
  before_save -> {
    self.name = csv_file.blob.filename
    self.path = csv_path
    self.headers = csv_headers 
  }
  enum status: {waiting: 0, processing: 1, failed: 2, finished: 3}
  attr_accessor :failed_contacts_count, :success_contacts_count

  has_one_attached :csv_file, dependent: :destroy
  has_many :failed_contacts

  validates :csv_file, attached: true, content_type: ["text/csv"]
  validate :validate_empty_file

  def import(map_headers)
    success = false
    map_headers.symbolize_keys!
    CSV.foreach(path, headers: true) do |row|
      self.processing!
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

  private
  def validate_empty_file
    if csv_file.present?
      self.errors.add(:csv_file, :blank) if csv_headers.empty? 
    end
  end

  def csv_headers
    CSV.open(csv_path, headers: true).read.headers
  end

  def csv_path
    if Rails.env.production?
      csv_file.url
    else
      ActiveStorage::Blob.service.send(:path_for, csv_file.key)
    end
  end
end
