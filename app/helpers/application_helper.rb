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
  
end
