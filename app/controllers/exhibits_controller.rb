class ExhibitsController < ApplicationController

  def show
    redirect_to exhibit_showcases_path(params[:id])
  end

end
