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
      redirect_to showcase_path(@showcase)
    else
      render :new
    end
  end

  def show
    showcase = ShowcaseQuery.new.find(params[:id])
    check_user_curates!(showcase.collection)
    @showcase = ShowcaseDecorator.new(showcase)
    if request.xhr?
      render format: :json
    else
      respond_to do |format|
        format.html { redirect_to edit_showcase_path(showcase.id) }
        format.json
      end
    end
  end

  def edit
    @showcase = ShowcaseQuery.new.find(params[:id])
    check_user_curates!(@showcase.collection)
  end

  def update
    @showcase = ShowcaseQuery.new.find(params[:id])
    check_user_curates!(@showcase.collection)

    if SaveShowcase.call(@showcase, save_params)
      flash[:notice] = t('.success')
      redirect_to showcase_path(@showcase)
    else
      render :edit
    end
  end

  def title
    @showcase = ShowcaseQuery.new.find(params[:id])
    check_user_curates!(@showcase.collection)
  end

  def destroy
    @showcase = ShowcaseQuery.new.find(params[:id])
    check_user_curates!(@showcase.collection)

    @showcase.destroy!()

    flash[:notice] = t('.success')
    redirect_to exhibit_path(@showcase.exhibit)
  end

  protected

    def save_params
      params.require(:showcase).permit([:title, :description])
    end

    def showcase
      @showcase ||= ShowcaseQuery.new.find(params[:id])
    end

    def exhibit
      @exhibit ||= ExhibitQuery.new.find(params[:exhibit_id])
    end

end
