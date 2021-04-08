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
    # begin
    #   if Contact.from_csv(params[:file]).failed_instances.empty? 
    #     flash[:notice] = "Employees imported successfully"
    #   else 
    #     flash[:alert] = "There is a problem with one or more records of your csv file"
    #   end
    # rescue => e
    #   puts e.message
    #   flash[:alert] = "There was a problem with your file or your file records."
    # end
    # redirect_to root_path
  end

  def create 
  end

  def destroy
  end
end