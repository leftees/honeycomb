class CuratorsController < ApplicationController
  def index
    @collection = CollectionQuery.new.find(params[:collection_id])
    check_user_curates!(@collection)
    collection_users = @collection.collection_users
    @curator_list = CollectionUserListDecorator.new(collection_users)

    # @current = CollectionUser.where(collection_id: @collection.id).map { |cu|
    #   cu.user.attributes
    # }
    # priority_list = Hash.new
    # @priority = CollectionUser.all.map { |cu|
    #   unless priority_list.has_key?(cu.user.username)
    #     priority_list[cu.user.username] = 1
    #     cu.user.attributes
    #   end
    # }
  end

  def create
    collection = CollectionQuery.new.find(params[:collection_id])
    check_user_curates!(collection)

    user =  FindOrCreateUser.call(create_params[:username])
    if collection_user = AssignUserToCollection.call(collection, user)
      @collection_user = CollectionUserDecorator.new(collection_user)
      respond_to do |format|
        format.any { render json: @collection_user.curator_hash, status: 200 }
      end
    else
      respond_to do |format|
        format.any { render json: { status: 'error'}, status: 500 }
      end
    end
  end

  def destroy
    @collection = CollectionQuery.new.find(params[:collection_id])
    check_user_curates!(@collection)

    @user =  User.find(params[:id])
    if @user.present?
      if RemoveUserFromCollection.call(@collection, @user)
        flash[:notice] = "Removed curator " + @user.name
      else
        flash[:error] = "Could not remove specified curator"
      end
    end
    redirect_to collection_curators_path(@collection.id)
  end

  private

  def create_params
    params.require(:user).permit(:username)
  end
end
