class Contact < ApplicationRecord
  include BCrypt
  before_save -> {
    self.card_last_four_digits = @card_number[-4..-1]
    self.card_franchise = credit_card_franchise(@card_number)
    @card_number = Password.create(@card_number)
    self.card_number_hash = @card_number
  }
  belongs_to :user
  validates :name, presence: true, format: {with: /\A[a-zA-Z0-9 -]*\z/, multiline: true}
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true
  validates :phone, presence: true, format: {with: /\A\(\+\d{2}\) (\d{3} \d{3} \d{2} \d{2}|\d{3}-\d{3}-\d{2}-\d{2})$\z/}
  validates :birth_date, presence: true
  validates :card_number, presence: true
  validate :valid_card?
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

  def credit_card_franchise(card_number)
    number = card_number.to_s.gsub(/\D/, "") 
    return "Dinner's club" if number.length == 14 && number =~ /^3(0[0-5]|[68])/   # 300xxx-305xxx, 36xxxx, 38xxxx
    return "American Express"     if number.length == 15 && number =~ /^3[47]/            # 34xxxx, 37xxxx
    return "Visa"    if [13,16].include?(number.length) && number =~ /^4/    # 4xxxxx
    return "Mastercard"   if number.length == 16 && number =~ /^5[1-5]/           # 51xxxx-55xxxx
    return "Discover" if number.length == 16 && number =~ /^6011/             # 6011xx
    return nil
  end

  private 

  def valid_card?
    number = self.card_number_hash.to_s.gsub(/\D/, "")
    errors.add(:card_number, :invalid) if credit_card_franchise(card_number).nil? 
    return false
    number.reverse!
    relative_number = {'0' => 0, '1' => 2, '2' => 4, '3' => 6, '4' => 8, '5' => 1, '6' => 3, '7' => 5, '8' => 7, '9' => 9}
    sum = 0 
    number.split("").each_with_index do |n, i|
      sum += (i % 2 == 0) ? n.to_i : relative_number[n]
    end
    errors.add(:card_number, :invalid) if sum % 10 != 0
  end

end
