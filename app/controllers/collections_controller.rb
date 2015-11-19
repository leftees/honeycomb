class CollectionsController < ApplicationController
  def index
    @collections = CollectionQuery.new.for_editor(current_user)
    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Collections,
                                         action: "index",
                                         collections: @collections)
    fresh_when(etag: cache_key.generate)
  end

  def show
    redirect_to collection_items_path(params[:id])
  end

  def new
    check_admin_or_admin_masquerading_permission!

    @collection = CollectionQuery.new.build
  end

  def create
    check_admin_or_admin_masquerading_permission!

    @collection = CollectionQuery.new.build

    if SaveCollection.call(@collection, save_params)
      flash[:notice] = t(".success")
      redirect_to collection_path(@collection)
    else
      render :new
    end
  end

  def edit
    @collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(@collection)

    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Collections,
                                         action: "edit",
                                         collection: @collection)
    fresh_when(etag: cache_key.generate)
  end

  def update
    @collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(@collection)

    if SaveCollection.call(@collection, save_params)
      flash[:notice] = t(".success")
      redirect_to edit_collection_path(@collection)
    else
      render :edit
    end
  end

  def destroy
    check_admin_or_admin_masquerading_permission!

    @collection = CollectionQuery.new.find(params[:id])
    Destroy::Collection.new.cascade!(collection: @collection)

    flash[:notice] = t(".success")
    redirect_to collections_path
  end

  def site_setup
    @collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(@collection)

    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Collections,
                                         action: "site_setup",
                                         collection: @collection)
    fresh_when(etag: cache_key.generate)
  end

  def site_setup_update # rubocop:disable Metrics/AbcSize
    @collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(@collection)

    if SaveCollection.call(@collection, save_params)
      flash[:notice] = t(".success")
      redirect_to site_setup_form_collection_path(@collection, form: params[:form])
    else
      render :site_setup
    end
  end

  def publish
    collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(collection)

    if Publish.call(collection)
      flash[:notice] = t(".success")
      redirect_to edit_collection_path(collection)
    else
      render :edit
    end
  end

  def unpublish
    collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(collection)

    if Unpublish.call(collection)
      flash[:notice] = t(".success")
      redirect_to edit_collection_path(collection)
    else
      render :edit
    end
  end

  def image_upload
    collection = CollectionQuery.new.any_find(params[:id])
    check_user_edits!(collection)
    item_query = ItemQuery.new(collection.items)
    @item = item_query.build

    if SaveItem.call(@item, save_item_params)
      flash[:success] = "Item created"
      new_item = item_query.find(Item.last.id)
      respond_to do |format|
        format.any do
          render json: {
            filelink: new_item.honeypot_image.json_response["thumbnail/medium"]["contentUrl"],
            title: new_item.name,
            unique_id: new_item.unique_id
          }.to_json
        end
      end
    else
      flash[:error] = "Item not created"
      respond_to do |format|
        format.any { render json: { status: "error" }, status: 500 }
      end
    end
  end

  protected

  def save_item_params
    params.permit(:name, :uploaded_image)
  end

  def save_params
    params.require(:collection).permit(
      :name_line_1,
      :name_line_2,
      :description,
      :id,
      :enable_search,
      :enable_browse,
      :site_intro,
      :short_intro,
      :hide_title_on_home_page,
      :uploaded_image,
      :about,
      :copyright)
  end
end
