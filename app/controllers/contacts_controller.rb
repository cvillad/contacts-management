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
  end

  def create
    @contact_file = current_user.contact_files.find(params[:file_id])
    Contact.from_csv(current_user, @contact_file, contact_params_mapped)
    redirect_to :index
  end

  def destroy
    @contact.destroy
  end

  private

  def set_contact 
    @contact = current_user.contacts.find(params[:id])
  end

  def contact_params_mapped 
    params.permit(Contact.attribute_names(&:to_sym)).to_h
  end
end