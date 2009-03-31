module PicksHelper

  def my_team?(team_id)
    current_user.id == team_id ? true : false
  end

end
