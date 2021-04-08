class Contact < ApplicationRecord
  belongs_to :user
  before_save -> {self.card_franchise = credit_card_franchise}
  validates :name, presence: true, format: {with: /\A[a-zA-Z -]*\z/, multiline: true}
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true
  validates :phone, presence: true, format: {with: /\A\(\+\d{2}\) (\d{3} \d{3} \d{2} \d{2}|\d{3}-\d{3}-\d{2}-\d{2})$\z/}
  validates :born_date, presence: true
  validates :card_number, presence: true
  validate :validate_credit_card
  validates_each :born_date_before_type_cast do |record, attribute, value|
    begin
      value.include?("-") ? Date.strptime(value.to_s,"%F") : Date.strptime(value.to_s,"%Y%m%d")
    rescue
      record.errors.add(:born_date, :invalid)
    end
  end

  def format_born_date
    self[:born_date].strftime("%Y %B %d") if self[:born_date]
  end

  def validate_credit_card
    number = self[:card_number].to_s.gsub(/\D/, "")
    errors.add(:card_number, :invalid) if credit_card_franchise.nil? 
    number.reverse!
    relative_number = {'0' => 0, '1' => 2, '2' => 4, '3' => 6, '4' => 8, '5' => 1, '6' => 3, '7' => 5, '8' => 7, '9' => 9}
    sum = 0 
    number.split("").each_with_index do |n, i|
      sum += (i % 2 == 0) ? n.to_i : relative_number[n]
    end
    errors.add(:card_number, :invalid) if sum % 10 != 0
  end
  
  def credit_card_franchise
    number = self[:card_number].to_s.gsub(/\D/, "") 
    return "Dinner's club" if number.length == 14 && number =~ /^3(0[0-5]|[68])/   # 300xxx-305xxx, 36xxxx, 38xxxx
    return "American Express"     if number.length == 15 && number =~ /^3[47]/            # 34xxxx, 37xxxx
    return "Visa"    if [13,16].include?(number.length) && number =~ /^4/    # 4xxxxx
    return "Mastercard"   if number.length == 16 && number =~ /^5[1-5]/           # 51xxxx-55xxxx
    return "Discover" if number.length == 16 && number =~ /^6011/             # 6011xx
    return nil
  end

end
