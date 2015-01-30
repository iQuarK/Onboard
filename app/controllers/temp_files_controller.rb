class TempFilesController < ApplicationController

  before_filter :authenticate_user!

  # -------------------------------------------------------------------------------------------------------------------
  # POST /temp_files
  # -------------------------------------------------------------------------------------------------------------------
  def create
    @temp_file = TempFile.create(temp_file_params)
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Private
  # -------------------------------------------------------------------------------------------------------------------
  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def temp_file_params
    params.require(:temp_file).permit(:file)
  end

end
