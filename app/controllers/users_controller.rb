class UsersController < ApplicationController
  before_filter :login_required, :only => [:index]

  def index
    @users = User.find(:all)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new(:invitation_token => params[:invitation_token])
    @user.email = @user.invitation.recipient_email if @user.invitation
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      if params[:user][:avatar].blank?
        flash[:notice] = "Thanks for signing up! Please check your email to activate your account."
        redirect_to root_url
      else
        render :action => 'crop'
      end
    else
      render :action => 'new'
    end
  end

  def edit    
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      if params[:user][:avatar].blank?
        flash[:notice] = "Successfully updated user."
        redirect_to @user
      else
        render :action => "crop"
      end
    else
      render :action => 'edit'
    end
  end
  
  def destroy    
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    redirect_to users_url
  end
  
  ## 
  # Make these following methods RESTFUL (i.e. put them in their own controllers)
  # Also, do we really need UserObserver to send the emails? 

  ##
  # Why does 'if current_user' work and not 'if logged_in?' ?
  # logged_in? should be in the scope here...
  def activate
    current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if current_user && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_to root_url
  end

  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if request.post?
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        current_user = @user
        @user.delete_reset_code
        flash[:notice] = "Password reset successfully for #{@user.email}"
        redirect_to root_url
      else
        render :action => :reset
      end
    end
  end

  def forgot
    if request.post?
      user = User.find_by_email(params[:user][:email])
      if user
        user.create_reset_code
        flash[:notice] = "Reset code sent to #{user.email}"
        redirect_to login_path
      else
        flash[:error] = "#{params[:user][:email]} does not exist in system"
        redirect_to login_path
      end
    end
  end

end
