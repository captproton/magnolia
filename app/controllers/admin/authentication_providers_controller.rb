class Admin::AuthenticationProvidersController < ApplicationController
  
  layout 'full_width'
  
  # GET /admin_authentication_providers
  # GET /admin_authentication_providers.xml
  def index
    @authentication_providers = AuthenticationProvider.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @authentication_providers }
    end
  end

  # GET /admin_authentication_providers/1
  # GET /admin_authentication_providers/1.xml
  def show
    @authentication_provider = AuthenticationProvider.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @authentication_provider }
    end
  end

  # GET /admin_authentication_providers/new
  # GET /admin_authentication_providers/new.xml
  def new
    
    authentication_providers = AuthenticationProvider.find(:all)
    @authentication_provider_types = authentication_providers.map{ |ap| ap['type'] }.uniq.compact
    @authentication_provider = AuthenticationProvider.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @authentication_provider }
    end
  end

  # POST /admin_authentication_providers
  # POST /admin_authentication_providers.xml
  def create
    @authentication_provider = AuthenticationProvider.new(params[:authentication_provider])

    respond_to do |format|
      if @authentication_provider.save
        flash[:notice] = 'AuthenticationProvider was successfully created.'
        format.html { redirect_to( admin_authentication_provider_path(@authentication_provider) ) }
        format.xml  { render :xml => @authentication_provider, :status => :created, :location => @authentication_provider }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @authentication_provider.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /admin_authentication_providers/1/edit
  def edit
    authentication_providers = AuthenticationProvider.find(:all)
    @authentication_provider_types = authentication_providers.map{ |ap| ap['type'] }.uniq.compact
    @authentication_provider = authentication_providers.find{ |ap| ap.id == params[:id].to_i }
  end

  # PUT /admin_authentication_providers/1
  # PUT /admin_authentication_providers/1.xml
  def update
    @authentication_provider = AuthenticationProvider.find(params[:id])
    
    respond_to do |format|
      if @authentication_provider.update_attributes( params[:authentication_provider] ) && @authentication_provider.update_attribute(:type, params[:authentication_provider][:type])
        flash[:notice] = 'AuthenticationProvider was successfully updated.'
        format.html { redirect_to( admin_authentication_provider_path(@authentication_provider) ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @authentication_provider.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_authentication_providers/1
  # DELETE /admin_authentication_providers/1.xml
  def destroy
    @authentication_provider = AuthenticationProvider.find(params[:id])
    @authentication_provider.destroy

    respond_to do |format|
      format.html { redirect_to(admin_authentication_providers_url) }
      format.xml  { head :ok }
    end
  end
end
