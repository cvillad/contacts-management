class ContactsController < ApplicationController 
  before_action :authenticate_user!
  def index
    @contacts = current_user.contacts
    respond_to do |format|
      format.html
      format.csv { send_data @contacts.to_csv, filename: "contacts-#{Date.today}.csv" }
    end
  end

  def new
  end

  def create 
  end

  def destroy
  end

  private

  def contact_params_mapped 
    params.permit(Contact.attribute_names(&:to_sym))
  end
end