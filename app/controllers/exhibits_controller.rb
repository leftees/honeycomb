class ExhibitsController < ApplicationController

  def show
    redirect_to exhibit_showcases_path(params[:id])
  end

  def edit
    @exhibit = ExhibitQuery.new.find(params[:id])
    check_user_curates!(@exhibit.collection)
  end
end
