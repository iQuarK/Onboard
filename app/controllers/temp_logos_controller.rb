class TempLogosController < ApplicationController

  before_filter :authenticate_user!

  # -------------------------------------------------------------------------------------------------------------------
  # POST /temp_logos
  # -------------------------------------------------------------------------------------------------------------------
  def create
    @temp_logo = TempLogo.create(temp_logo_params)
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Private
  # -------------------------------------------------------------------------------------------------------------------
  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def temp_logo_params
    params.require(:temp_logo).permit(:logo)
  end

end
