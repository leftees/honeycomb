class PagesController < ApplicationController
  def index
    check_user_edits!(collection)
    @pages = PageQuery.new(collection.pages).ordered
    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Pages,
                                         action: "index",
                                         collection: collection)
    fresh_when(etag: cache_key.generate)
  end

  def new
    check_user_edits!(collection)
    @page = PageQuery.new(collection.pages).build
  end

  def create
    check_user_edits!(collection)
    @page = PageQuery.new(collection.pages).build(save_params)

    if SavePage.call(@page, save_params)
      flash[:notice] = t(".success")
      redirect_to page_path(@page)
    else
      render :new
    end
  end

  def show
    @page = PageQuery.new.find(params[:id])
    check_user_edits!(page.collection)
    redirect_to edit_page_path(page.id)
  end

  def edit
    @page = PageQuery.new.find(params[:id])
    check_user_edits!(@page.collection)
    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Pages,
                                         action: "edit",
                                         page: @page)
    fresh_when(etag: cache_key.generate)
  end

  def update
    @page = PageQuery.new.find(params[:id])
    check_user_edits!(@page.collection)

    if SavePage.call(@page, save_params)
      flash[:notice] = t(".success")
      redirect_to page_path(@page)
    else
      render :edit
    end
  end

  def destroy
    @page = PageQuery.new.find(params[:id])
    check_user_edits!(@page.collection)
    Destroy::Page.new.cascade!(page: @page)

    flash[:notice] = t(".success")
    redirect_to collection_pages_path(@page.collection)
  end

  protected

  def save_params
    params.require(:page).permit([
      :name,
      :content
    ])
  end

  def page
    @page ||= PageQuery.new.find(params[:id])
  end

  def collection
    @collection ||= CollectionQuery.new.find(params[:collection_id])
  end
end
