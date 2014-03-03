
class SubjectsController < ApplicationController
  def index
  end

  def show
  	@hex = {"bubble" => "#3c8999", "cluster" => "#99843c", "ego" => "#3f993c", "galaxy" => "#993c64", "other" => "#5f3c99"}
    @s = Subject.find_by_zooniverse_id(params[:zoo_id])
    @results = @s.dbscan
  end
end
