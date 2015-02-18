class ExhibitsController < ApplicationController

  def new
    @exhibit = collection.exhibits.build
  end

  def create
    @exhibit = collection.exhibits.build(save_params)

    if @exhibit.save
      redirect_to collection_exhibit_showcases_path(@exhibit.collection, @exhibit)
    else
      render :new
    end
  end

  def edit
    @exhibit = collection.exhibits.find(params[:id])
  end

  def update
    @exhibit = collection.exhibits.find(params[:id])

    if @exhibit.update_attributes(save_params)
      redirect_to edit_collection_exhibit_path(@exhibit.collection, @exhibit)
    else
      render :edit
    end
  end

  def destroy
    @exhibit = collection.exhibits.find(params[:id])

    if @exhibit.destroy()
      redirect_to exhibits_path
    end
  end

  def items
    @exhibit = collection.exhibits.find(params[:id])

    respond_to do |format|
      format.json do
        require 'open-uri'
        json_contents = open(@exhibit.items_json_url) {|io| io.read}
        render json: json_contents
      end
    end
  end

  protected

    def save_params
      params.require(:exhibit).permit([:title, :collection_id])
    end

    def collection
      @collection ||= Collection.find(params[:collection_id])
    end
end
