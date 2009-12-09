class PhotosController < ApplicationController
  def index
    @photos = Photo.public
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
      redirect_to @photo
    else
      render :action => 'new'
    end
  end
  
  def update
     @photo = Photo.find(params[:id])
     if @photo.update_attributes(params[:photo])
       flash[:notice] = "Successfully updated photo."
       redirect_to @photo
     else
       render :action => 'edit'
     end
   end
   
  def edit
    @photo = Photo.find(params[:id])
  end
  
  def flag
    @photo = Photo.find(params[:id])
    @photo.flag
    redirect_to @photo
  end
  
end
