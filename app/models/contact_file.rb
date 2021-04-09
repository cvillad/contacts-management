class ContactFile < ApplicationRecord
  belongs_to :user
  after_initialize :set_params

  has_one_attached :csv_file, dependent: :destroy
  validates :csv_file, content_type: ["text/csv"]

  def set_params
  end

end
