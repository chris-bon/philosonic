class ApplicationController < ActionController::Base

  def forem_user
    current_user
  end
  helper_method :forem_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def frontpage
  end
  def about
  end
  def contact
  end
  def timeline
  end

  # GET '/musician_seeker'  # Musician search form
  def musician_seeker
    
  end
  # GET '/musicians_index'  # Return musicians after submitting search request
  def musicians_index
    @musicians = Profile.all
  end

  ### Under Construction! ###
  # GET '/jamseeker'
  def jamseeker
  end
  # GET '/drumcircles'
  def drumcircles
  end
  # GET '/remixes'
  def remixes
  end
  ###

  protected
  
  def configure_permitted_parameters
    added_attributes = [:username, :email, :password, :password_confirmation, 
                        :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attributes
    devise_parameter_sanitizer.permit :account_update, keys: added_attributes
  end
end
