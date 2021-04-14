class Contact < ApplicationRecord
  include BCrypt
  require 'credit_card_validations/string'

  before_save -> {
    self.card_last_four_digits = @card_number[-4..-1]
    self.card_franchise = @card_number.credit_card_brand_name
    @card_number = Password.create(@card_number)
    self.card_number_hash = @card_number
  }
  belongs_to :user
  validates :name, presence: true, format: {with: /\A[a-zA-Z0-9 -]*\z/, multiline: true}
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true
  validates :phone, presence: true, format: {with: /\A\(\+\d{2}\) \d{3}([- ])\d{3}\1\d{2}\1\d{2}\z/}
  validates :birth_date, presence: true
  validates :card_number, presence: true, credit_card_number: true
  validates_each :birth_date_before_type_cast do |record, attribute, value|
    begin
      value.include?("-") ? Date.strptime(value, "%F") : Date.strptime(value, "%Y%m%d")
    rescue
      record.errors.add(:birth_date, :invalid)
    end
  end

  def card_number
    @card_number ||= Password.new(card_number_hash) if card_number_hash.present?
  end

  def card_number=(new_card_number)
    @card_number = new_card_number
    self.card_number_hash = new_card_number
  end

  def self.to_csv
    attributes = %w{name email address phone birth_date card_number card_franchise}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |contact|
        csv << attributes.map{ |attr| contact.send(attr) }
      end
    end
  end

  def format_birth_date
    self[:birth_date].strftime("%Y %B %d") if self[:birth_date]
  end

end
