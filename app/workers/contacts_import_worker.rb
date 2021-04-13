class ContactsImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(contact_file_id, headers)
    contact_file = ContactFile.find(contact_file_id)
    contact_file.processing!
    contact_file.import(headers)
  end
end