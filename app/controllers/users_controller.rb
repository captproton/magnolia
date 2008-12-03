class UsersController < ApplicationController

  include OpenIdUtils
  
  layout 'full_width'
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :index]
  
  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    
    respond_to do |format|
      format.html do
        case params[:registration_method]   
        when 'third_party'
          render :template => 'users/third_party'  
        end
      end
    end
  end
    
  # GET /users/1
  # GET /users/1.xml
  # This action will be for displaying a user's profile page. Probably will just redirect to a 'People' resource.
  def show
    @user = User.find( params[:id] )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  private
    
    def email_authentication
      if user = User.find_by_email( params[:openid_identifier] )
        flash[:error] = 'This email is already in use.'
        @openid_identifier = params[:openid_identifier]
        render :template => 'users/third_party'
      else
        authenticate_new_user
      end
    end
    
    # POST /users
    # POST /users.xml
    def non_open_id_create
      @user = User.new(params[:user])

      respond_to do |format|
        if @user.save
          flash[:notice] = "Account registered!"
          format.html { redirect_back_or_default user_url(@user) }
          format.xml  { render :xml => @user, :status => :created, :location => @user }
        else
          format.html { render :action => :new }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    end
  
end
