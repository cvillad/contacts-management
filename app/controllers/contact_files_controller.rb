class ContactFilesController < ApplicationController
  before_action :authenticate_user!
  def index 
    @files = current_user.contact_files.order(created_at: :desc)
  end

  def new
  end

  def create
    file = contact_file_params[:file]
    @contact_file = current_user.contact_files.build(name: file.original_filename, headers: csv_headers)
    @contact_file.save!
    @contact_file.csv_file.attach(file)
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

end