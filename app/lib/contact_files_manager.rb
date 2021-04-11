
class ContactFilesManager
  attr_reader :contact_file

  def initialize(user, file)
    uploaded_file = ActiveStorage::Blob.create_and_upload!(
      io: File.open(file, 'rb'),
      filename: file.original_filename,
      content_type: 'text/csv'
    )
    @contact_file = user.contact_files.build(csv_file: uploaded_file)
  end

end