class UsersController < ApplicationController

  layout 'basic'
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :index]
  
  def index
    @users = User.find :all
    respond_to do |format|
      format.html { render :layout => 'full_width' }
      format.xml  { render :xml => @users }
    end
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
        format.html { redirect_back_or_default user_url(@user) }
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
    @user = User.find( params[:id] )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

end
