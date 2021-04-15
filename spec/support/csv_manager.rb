module CSVManager
  def self.load(file)
    csv_file = ActiveStorage::Blob.create_and_upload!(
        io: File.open(file, 'rb'),
        filename: 'contacts.csv',
        content_type: 'text/csv'
    ).signed_id
  end
end