class ShowcasesController < ApplicationController

  def index
    check_user_curates!(exhibit.collection)
    @showcases = ShowcaseQuery.new(exhibit.showcases).all
  end

  def new
    check_user_curates!(exhibit.collection)
    @showcase = ShowcaseQuery.new(exhibit.showcases).build
  end

  def create
    check_user_curates!(exhibit.collection)
    @showcase = ShowcaseQuery.new(exhibit.showcases).build(save_params)

    if SaveShowcase.call(@showcase, save_params)
      flash[:notice] = t('.success')
      redirect_to exhibit_showcases_path(@showcase.exhibit.id)
    else
      render :new
    end
  end



  def edit
    @showcase = exhibit.showcases.find(params[:id])
  end

  def update
    @showcase = exhibit.showcases.find(params[:id])

    if @showcase.update_attributes(save_params)
      redirect_to exhibit_showcases_path(@showcase.exhibit)
    else
      render :edit
    end
  end

  def destroy
    @showcase = exhibit.showcases.find(params[:id])

    if @showcase.destroy()
      redirect_to exhibit_showcases_path(@showcase.exhibit)
    end
  end

  protected

    def save_params
      params.require(:showcase).permit([:title])
    end

    def exhibit
      @exhibit ||= ExhibitQuery.new.find(params[:exhibit_id])
    end

end
