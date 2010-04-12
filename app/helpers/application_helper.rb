# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def draft_started?
    Pick.count > 0 && Pick.taken.size > 0
  end

  def draft_over?
    Pick.taken.count >= Pick.count
  end

  def is_admin?
    current_user.role.match('admin')
  end

  def ba(average)
    # we assume that you will get a float that looks like this 0.342
    # we want to print something like .342
    # convert to string, pad right with zeros then chop leading zero
    d = average.to_s
    while d.length < 5
      d << "0"
    end
    return d.gsub("0\.","\.")
  end

  def flash_helper
      f_names = [:warning, :message, :error]
      fl = ''
      for name in f_names
        if flash[name]
          fl = fl + "<div id=\"errorExplanation\">#{flash[name]}</div>"
        end
      flash[name] = nil;
    end
    return fl
  end
  
  def player_picture(player_yahoo_ref)
    image_tag("http://l.yimg.com/a/i/us/sp/v/mlb/players_l/20090407/#{player_yahoo_ref}.jpg", :size => "65x85")
  end
  
  def round_number(pick_number, teams)
    # return round number
    (pick_number/teams).to_i
  end
  
end
