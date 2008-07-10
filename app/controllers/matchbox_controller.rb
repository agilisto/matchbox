class MatchboxController < ApplicationController
  skip_before_filter :admin_site_required
  skip_before_filter :login_required
  before_filter :site_required
  
  def show
    respond_to do |format|
      format.xml
    end
  end
end
