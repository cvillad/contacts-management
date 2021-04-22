class ContactsImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(contact_file_id)
    contact_file = ContactFile.find(contact_file_id)
    contact_file.processing!
    ActionCable.server.broadcast "contact_files_channel:#{contact_file.user_id}", { status: contact_file.status, id: contact_file.id }
    contact_file.import
    ActionCable.server.broadcast "contact_files_channel:#{contact_file.user_id}", { status: contact_file.status, id: contact_file.id }
  end
end