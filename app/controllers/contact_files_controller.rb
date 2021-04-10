class ContactFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact_file, only:[:import, :match_headers, :destroy]

  def index 
    @files = current_user.contact_files.order(created_at: :desc)
  end

  def match_headers
    @headers = @contact_file.csv_headers 
  end

  def import
    @contact_file.import(current_user, mapped_headers)
    flash[:notice] = "Importing records from csv file..."
    redirect_to contact_files_path
  end

  def create
    if params[:contact_file].present?
      file = contact_file_params[:file]
      csv_file = ActiveStorage::Blob.create_and_upload!(
        io: File.open(file, 'rb'),
        filename: file.original_filename,
        content_type: 'text/csv'
      )
      @contact_file = current_user.contact_files.build(csv_file: csv_file)
      if @contact_file.save
        flash[:notice] = "File uploaded successfully"
        redirect_to contact_files_path
      else
        flash[:alert] = "There was a problem with your file"
        redirect_to contacts_path
      end
    else
      flash[:alert] = "No file provided"
      redirect_to contacts_path
    end
  end

  def destroy
    if @contact_file.destroy
      flash[:notice] = "File deleted successfully"
    else  
      flash[:alert] = "There was a problem to delete this file"
    end
    redirect_to contact_files_path
  end

  private 
  def contact_file_params
    params.require(:contact_file).permit(:file)
  end

  def set_contact_file 
    @contact_file = current_user.contact_files.find(params[:id])
  end

  def mapped_headers
    params.permit(:name, :birth_date, :phone, :address, :card_number, :email).to_h
  end

end