class Contact < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, format: {with: /\A[a-zA-Z0-9 ]*-*[a-zA-Z0-9 ]*\z/, multiline: true}
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :born_date, presence: true
  validates_each :born_date do |record, attribute, value|
    if !value.nil?
      begin
        value.to_s.include?("-") ? Date.strptime(value.to_s,"%F") : Date.strptime(value.to_s,"%Y%m%d")
      rescue
        record.errors.add(attribute, "invalid")
      end
    end
    
  end

  def format_born_date
    self[:born_date].strftime("%Y %B %d") if self[:born_date]
  end

end
