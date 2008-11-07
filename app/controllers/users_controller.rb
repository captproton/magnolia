class UsersController < ApplicationController

  layout 'basic'
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def index
    @users = User.find :all
    render :layout => 'full_width'
  end
  
  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = "Account registered!"
        format.html { redirect_back_or_default account_url }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  # GET /users/1
  # GET /users/1.xml
  # This action will be for displaying a user's profile page. Probably will just redirect to a 'People' resource.
  def show
    @user = @current_user

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def edit
    @user = @current_user
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes( params[:user] )
      flash[:notice] = "Account updated!"
      format.html { redirect_to account_url }
      format.xml  { render :xml => @user, :status => :created, :location => @user }
    else  
      format.html { render :action => :edit }
      format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
    end
  end

end
