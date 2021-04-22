class ContactFile < ApplicationRecord
  belongs_to :user
  enum status: {waiting: 0, processing: 1, failed: 2, finished: 3}

  has_one_attached :csv_file, dependent: :destroy
  has_many :failed_contacts

  validates :name, presence: true 
  validates :matched_headers, presence: true
  validates :headers, presence: true
  validates :csv_file, attached: true, content_type: ["text/csv"]
  validate :validate_empty_file

  def mapped_headers
    (JSON.parse matched_headers.gsub("=>", ":")).symbolize_keys
  end

  def import
    success, failed = 0, 0
    map_headers = mapped_headers
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
        success+=1
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
        failed+=1
      end
    end
    success > 0 || (success==0 && failed==0) ? self.finished! : self.failed!
  end

  private 
  def validate_empty_file
    errors.add(:csv_file, :blank) if headers.empty?
  end
end
