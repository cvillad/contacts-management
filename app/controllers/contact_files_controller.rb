class ContactFilesController < ApplicationController
  before_action :authenticate_user!
  def index 
    @files = current_user.contact_files.includes(:blob)
  end

  def new 
  end

  def create
    file = contact_file_params[:file]
    csv_headers = CSV.open(file.path, &:readline)
    @contact_file = current_user.contact_files.build(name: file.original_filename, headers: csv_headers)
    @contact_file.save!
    @contact_file.csv_file.attach(file)
    render :new, locals: {csv_headers: csv_headers}
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