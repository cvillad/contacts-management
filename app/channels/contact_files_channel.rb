class ContactFilesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "contact_files_channel:#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
  end
end
