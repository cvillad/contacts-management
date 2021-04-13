class ContactsImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(contact_file_id)
    contact_file = ContactFile.find(contact_file_id)
    contact_file.processing!
    contact_file.import
  end
end