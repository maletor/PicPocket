class PhotosController < ApplicationController
  def destroy
    @photo = photo.find(params[:id])
    @photo.destroy
    user = @photo.attachable
    @allowed = 5 - user.photos.count
  end
end
