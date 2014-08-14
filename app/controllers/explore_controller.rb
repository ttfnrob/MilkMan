
class ExploreController < ApplicationController
  def index
  	@pagetitle = "Milkman: Data Explorer"
  	render :layout => "explore"
  end
end
