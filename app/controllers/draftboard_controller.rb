class DraftboardController < ApplicationController

  def index
    @picks = Pick.taken
    render :layout => false
  end
  
end
