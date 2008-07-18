class MatchboxController < ApplicationController
  skip_before_filter :login_required
  session :off
  
  # Just to prevent routing errors if the xml file doesn't exist.
  def default
    render :text => "", :status => 404
  end
end
