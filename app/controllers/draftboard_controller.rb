class DraftboardController < ApplicationController

  def index
    @picks = Pick.taken
    @pick_current = Pick.current.first
    render :layout => false
  end
  
end
