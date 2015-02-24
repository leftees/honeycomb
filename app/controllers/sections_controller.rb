class SectionsController < ApplicationController

  def index
    check_user_curates!(showcase.exhibit.collection)
    @sections = ShowcaseList.new(SectionQuery.new(showcase.sections).all_in_showcase, showcase)
  end

  def new
    @section_form = SectionForm.build_from_params(self)
    check_user_curates!(@section_form.collection)
  end

  def create
    @section = showcase.sections.build

    respond_to do |format|
      if SaveSection.call(@section, section_params)
        format.html { redirect_to exhibit_showcase_sections_path(exhibit.id, showcase.id), notice: 'Section Created' }
        format.json { render :show, status: :created, location: showcase_section_path(showcase, @section) }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @section_form = SectionForm.build_from_params(self)
  end

  def update
    @section = showcase.sections.find(params[:id])

    respond_to do |format|
      if SaveSection.call(@section, section_params)
        format.html { redirect_to exhibit_showcase_sections_path(exhibit.id, showcase.id), notice: 'Section updated.' }
        format.json { render :show, status: :updated, location: @section }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @section = showcase.sections.find(params[:id])

    respond_to do |format|

      if @section.destroy
        format.json { render json: 'Section deleted successfully', status: 202 }
        format.any { redirect_to  exhibit_showcase_sections_path(exhibit.id, showcase.id) }
      end

    end
  end

  protected

    def section_params
      params.require(:section).permit(:title, :image, :item_id, :description, :order, :caption)
    end

    def showcase
      @showcase ||= ShowcaseQuery.new.find(params[:showcase_id])
    end
end
