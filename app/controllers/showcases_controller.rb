class ShowcasesController < ApplicationController

  def index
    @showcases = exhibit.showcases
  end


  def new
    @showcase = exhibit.showcases.build
  end

  def create
    @showcase = exhibit.showcases.build(save_params)

    if @showcase.save
      redirect_to exhibit_showcases_path(@showcase.exhibit)
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
      @exhibit ||= collection.exhibits.find(params[:exhibit_id])
    end

    def collection
      @collection ||= Collection.find(params[:collection_id])
    end
end
