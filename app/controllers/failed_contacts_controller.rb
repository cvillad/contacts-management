class FailedContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_failed_contact, only: :show

  def index  
    @failed_contacts = current_user.failed_contacts.order(created_at: :desc)
  end

  def show 
  end

  private 

  def set_failed_contact
    @failed_contact = current_user.failed_contacts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "You can only view your own failed contacts"
    redirect_to failed_contacts_path
  end

end