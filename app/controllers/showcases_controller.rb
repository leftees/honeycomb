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
    redirect_to edit_showcase_path(params[:id])
  end

  def edit
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
      params.require(:showcase).permit([:title])
    end

    def showcase
      @showcase ||= ShowcaseQuery.new.find(params[:id])
    end

    def exhibit
      @exhibit ||= ExhibitQuery.new.find(params[:exhibit_id])
    end

end
