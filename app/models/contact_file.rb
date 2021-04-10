class ContactFile < ApplicationRecord
  belongs_to :user

  has_one_attached :csv_file, dependent: :destroy
  validates :csv_file, content_type: ["text/csv"]

  def csv_path
    ActiveStorage::Blob.service.send(:path_for, csv_file.key)
  end
end
