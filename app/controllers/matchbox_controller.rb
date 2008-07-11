class MatchboxController < ApplicationController
  skip_before_filter :admin_site_required
  skip_before_filter :login_required
  before_filter :site_required
  session :off
  
  # caches_page :show, :controller => "matchbox", :action => "show" # expires after a reindex
  
  def show
    respond_to do |format|
      format.xml
    end
  end
end
