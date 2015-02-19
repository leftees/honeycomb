class CollectionsController < ApplicationController

  def index
    @collections = CollectionQuery.new.for_curator(current_user)
  end

  def new
    check_admin_or_admin_masquerading_permission!

    @collection = Collection.new
  end

  def create
    check_admin_or_admin_masquerading_permission!

    @collection = Collection.new(params.require(:collection).permit([:title]))

    if @collection.save and AssignUserToCollection.call(@collection, current_user)
      flash[:notice] = t('.success')
      redirect_to collection_items_path(@collection)
    else
      render :new
    end
  end

  def edit
    @collection = Collection.find(params[:id])

    check_user_curates!(@collection)
  end

  def update
    @collection = Collection.find(params[:id])
    check_user_curates!(@collection)

    if SaveCollection.call(@collection, save_params)
      flash[:notice] = t('.success')
      redirect_to edit_collection_path(@collection)
    else
      false
    end
  end

  def soft_delete
    check_admin_or_admin_masquerading_permission!

    @collection = Collection.find(params[:collection_id])
    SoftDeleteCollection.call(@collection)
    flash[:notice] = @collection.title + " has been deleted."
    redirect_to collections_path
  end

  def restore
    check_admin_or_admin_masquerading_permission!

    @collection = Collection.find(params[:collection_id])
    RestoreCollection.call(@collection)
    flash[:notice] = @collection.title + " has been restored."
    redirect_to collections_path
  end

  protected

    def save_params
      params.require(:collection).permit(:title, :description, :id)
    end

end
