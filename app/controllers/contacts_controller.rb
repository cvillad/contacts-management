class ContactsController < ApplicationController 
  before_action :authenticate_user!
  before_action :set_contact, only: :destroy

  def index
    @contacts = current_user.contacts.paginate(page: params[:page], per_page: 10)
    @contact_file = current_user.contact_files.build
    respond_to do |format|
      format.html
      format.csv { send_data @contacts.to_csv, filename: "contacts-#{Date.today}.csv" }
    end
  end

  def destroy
    if @contact.destroy
      flash[:notice] = "Contact deleted successfully"
    else
      flash[:alert] = "Cannot delete the contact"
    end
    redirect_to contacts_path
  end

  private

  def set_contact 
    @contact = current_user.contacts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Cannot delete the contact"
    redirect_to contacts_path
  end
end