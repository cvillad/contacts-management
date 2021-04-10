class ContactsController < ApplicationController 
  before_action :authenticate_user!
  before_action :set_contact, only: :destroy

  def index
    @contacts = current_user.contacts
    @contact_file = current_user.contact_files.build
    respond_to do |format|
      format.html
      format.csv { send_data @contacts.to_csv, filename: "contacts-#{Date.today}.csv" }
    end
  end

  def destroy
    @contact.destroy
  end

  private

  def set_contact 
    @contact = current_user.contacts.find(params[:id])
  end
end