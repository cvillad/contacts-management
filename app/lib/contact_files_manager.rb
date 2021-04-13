
class ContactFilesManager
  attr_reader :contact_file

  def initialize(user, file)
    # @file = ActiveStorage::Blob.create_and_upload!(
    #   io: File.open(file, 'rb'),
    #   filename: file.original_filename,
    #   content_type: 'text/csv'
    # )
    @file = file
    @contact_file = user.contact_files.build(csv_file: file, name: file.original_filename, headers: csv_headers)
  end

  def csv_headers
    CSV.open(@file.path, headers: true).read.headers
  end

end