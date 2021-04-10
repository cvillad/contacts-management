class ContactFilesController < ApplicationController
  before_action :authenticate_user!
  def index 
    @files = current_user.contact_files.order(created_at: :desc)
  end

  def match_headers
    @contact_file = current_user.contact_files.find(params[:id])
    @headers = @contact_file.csv_headers 
  end

  def import
    @contact_file = current_user.contact_files.find(params[:id])
    @contact_file.import(current_user, mapped_headers)
    redirect_to root_path
  end

  def create
    file = contact_file_params[:file]
    @contact_file = current_user.contact_files.build(csv_file: file)
    @contact_file
    @contact_file.save
    redirect_to contact_files_path
  end

  def destroy
    current_user.contact_files.find(params[:id]).purge
    redirect_to files_path
  end

  private 
  def contact_file_params
    params.require(:contact_file).permit(:file)
  end

  def mapped_headers
    params.permit(:name, :birth_date, :phone, :address, :card_number, :email).to_h
  end

end