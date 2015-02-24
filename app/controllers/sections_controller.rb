class SectionsController < ApplicationController

  def index
    check_user_curates!(showcase.exhibit.collection)
    @sections = ShowcaseList.new(SectionQuery.new(showcase.sections).all_in_showcase, showcase)
  end

  def new
    check_user_curates!(showcase.exhibit.collection)
    @section_form = SectionForm.build_from_params(self)
  end

  def create
    check_user_curates!(showcase.exhibit.collection)
    @section = SectionQuery.new(showcase.sections).build

    respond_to do |format|
      if SaveSection.call(@section, section_params)
        format.html { redirect_to showcase_sections_path(showcase.id), notice: 'Section Created' }
        format.json { render :show, status: :created, location: showcase_sections_path(showcase, @section) }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @section_form = SectionForm.build_from_params(self)
    check_user_curates!(@section_form.collection)
  end

  def update
    @section = SectionQuery.new.find(params[:id])
    check_user_curates!(@section.showcase.exhibit.collection)

    respond_to do |format|
      if SaveSection.call(@section, section_params)
        format.html { redirect_to showcase_sections_path(@section.showcase.id), notice: 'Section updated.' }
        format.json { render :show, status: :updated, location: @section }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @section = SectionQuery.new.find(params[:id])
    check_user_curates!(@section.showcase.exhibit.collection)

    @section.destroy!

    flash[:notice] = t('.success')
    redirect_to  showcase_sections_path(@section.showcase.id)
  end

  protected

    def section_params
      params.require(:section).permit(:title, :image, :item_id, :description, :order, :caption)
    end

    def showcase
      @showcase ||= ShowcaseQuery.new.find(params[:showcase_id])
    end
end
