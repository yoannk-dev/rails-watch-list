class BookmarksController < ApplicationController
  def new
    @bookmark = Bookmark.new
  end

  def create
    @list = List.find(params[:list_id] || bookmark_params[:list_id])
    @bookmark = Bookmark.new(bookmark_params.except(:list_id))
    @bookmark.list = @list

    if @bookmark.save
      redirect_to list_path(@list), notice: "Le film a bien été ajouté !"
    else
      render "lists/show", status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @list = List.find(@bookmark.list_id)
    @bookmark.destroy
    redirect_to list_path(@list), status: :see_other
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:comment, :movie_id, :list_id)
  end
end
