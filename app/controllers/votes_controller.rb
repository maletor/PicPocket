class VotesController < ApplicationController
  def create
    @vote = Vote.new(:user_id => current_user, :photo_id => params[:photo_id])
    if @vote.save
      @photo = Photo.find(@vote.photo_id)
      @photo.flag
      flash[:notice] = "Successfully created vote."
      redirect_to photo_url(@photo)
    else
      flash[:notice] = "Alrady cast vote."
      redirect_to :back
    end
  end
end
