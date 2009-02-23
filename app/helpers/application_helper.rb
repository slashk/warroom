# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def draft_started?
    false
  end

  def is_admin?
    true
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
