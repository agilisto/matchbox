class SitesController < ApplicationController
  before_filter :find_site, :except => [:index, :create, :new]

  # GET /sites
  # GET /sites.xml
  # Note: Room for more criteria, though we only have one for now: n=site name
  def index
    conditions = []
    criteria = []
    @filter = ""
    
    unless params[:n].blank?
      conditions << "name LIKE ?"
      criteria << "#{params[:n]}%"
      @filter = params[:n]
    end

    @sites = Site.find(:all, :conditions => [conditions.join(" AND "), *criteria]).paginate(:page => params[:page], :per_page => 20)
  end

  # GET /sites/1
  # GET /sites/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/new
  # GET /sites/new.xml
  def new
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(params[:site])

    respond_to do |format|
      if @site.save
        flash[:notice] = 'Site was successfully created.'
        format.html { redirect_to(@site) }
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = 'Site was successfully updated.'
        format.html { redirect_to(@site) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site.destroy

    respond_to do |format|
      format.html { redirect_to(sites_url) }
      format.xml  { head :ok }
    end
  end
  
  # POST /sites/1/fetch_stories
  # POST /sites/1/fetch_stories.xml
  def fetch_stories
    if !@site.fetch_stories
      flash[:error] = "Couldn't fetch the stories. Is it a proper feed?"
    else
      flash[:notice] = "Stories have been successfully updated."
    end
    redirect_to @site # TODO: Not the neatest way - but the easiest
  end

private 

  def find_site
    @site = Site.find(params[:id])
  end
  
end
