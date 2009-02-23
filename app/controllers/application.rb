# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # this is for restful authentication
  include AuthenticatedSystem


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '777b0c67942ff980eb19a6d597a92b2c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  def draft_started?
    Picks.count > 0
  end

  # find the team who is currently on the clock
  def find_team_on_clock
    pick_number = Pick.count
    t = User.find_by_draft_order(whose_pick((pick_number+1), DRAFT))
    #return t.short_name
  end
  
  # find the time of the last pick 
  # usually used in the view to calculate how long someone is taking to pick
  # use like this <%= time_ago_in_words(find_last_pick_time(), true) %>
  def find_last_pick_time
    last_pick_time = Pick.find(:first, :order => "pick_number desc").created_at
  end

end
