# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '7c7ec0ba19a2aee453bd2b3fdbac5430'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :password_confirmation

  before_filter :admin_site_required
  before_filter :login_required

protected

  # Will either fetch the current account or return nil if none is found
  def current_site
    @site ||= Site.find_by_identifier(current_subdomain)
  end
  # Make this method visible to views as well
  helper_method :current_site

  def admin_site_required
    if current_site
      render :file => "#{RAILS_ROOT}/public/403.html", :status => 403
      return false
    end
  end

  # This is a before_filter we'll use in controllers for news sites (like matchbox controller)
  def site_required
    unless current_site
      render :file => "#{RAILS_ROOT}/public/403.html", :status => 403
      return false
    end
  end

end
