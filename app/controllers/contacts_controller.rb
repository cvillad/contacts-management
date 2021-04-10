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

  def new
    @contact_file = current_user.contact_files.find(params[:file_id])
    file_path = ActiveStorage::Blob.service.send(:path_for, @contact_file.csv_file.key)
    @headers = CSV.open(file_path, &:readline)
  end

  def create
    @contact_file = current_user.contact_files.find(params[:file_id])
    Contact.from_csv(current_user, @contact_file, mapped_headers)
    redirect_to root_path
  end

  def destroy
    @contact.destroy
  end

  private

  def set_contact 
    @contact = current_user.contacts.find(params[:id])
  end

  def mapped_headers
    params.permit(:name, :birth_date, :phone, :address, :card_number, :email).to_h
  end
end