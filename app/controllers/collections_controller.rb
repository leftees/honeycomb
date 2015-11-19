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
    find_collection(params[:id])
    check_user_edits!(@collection)

    if SaveItem.call(new_item, save_item_params)
      flash[:success] = "Item created"
      render json: item_json
    else
      render json: { status: "error" }, status: 500
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
      :copyright,
      :site_objects)
  end

  private

  def find_collection(id)
    @collection = CollectionQuery.new.any_find(id)
  end

  def new_item
    ItemQuery.new(@collection.items).build
  end

  def last_item
    @last_item ||= ItemQuery.new(@collection.items).find(Item.last.id)
  end

  def item_json
    {
      filelink: last_item.honeypot_image.json_response["thumbnail/medium"]["contentUrl"],
      title: last_item.name,
      unique_id: last_item.unique_id
    }.to_json
  end
end
