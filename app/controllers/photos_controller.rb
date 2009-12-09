class PhotosController < ApplicationController
  def index
    @photos = Photo.find(:all)
  end
  
  def show
    @photo = Photo.find(params[:id])
  end
  
  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(params[:photo])
    if @photo.save
     current_user.photos << @photo if current_user
      flash[:notice] = "Successfully created photo."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def flag
    @photo = Photo.find(1)
    @photo.flag
    redirect_to @photo
  end
  
end
