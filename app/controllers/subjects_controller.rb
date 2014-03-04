class SubjectsController < ApplicationController
  def index
  end

  def show
  	@hex = {"bubble" => "#57D6E4", "cluster" => "#D1C056", "ego" => "#4FD84E", "galaxy" => "#D86593", "other" => "#8963DD"}
    @types = {"Bubbles"=>"bubble", "Clusters"=>"cluster", "EGOs"=>"ego", "Galaxies"=>"galaxy"}
    @s = Subject.find_by_zooniverse_id(params[:zoo_id])
    @results = @s.dbscan
    @simbad_gal = @s.simbad_gal_list
    @simbad = @s.simbad_for_svg
  end

  def examples
    @examples = ["AMW0002t48", "AMW0000ora"]
    @display = {}
    @examples.each do |e|
      s = Subject.find_by_zooniverse_id(e)
      results = s.dbscan
      @display[e] = results
    end

    @hex = {"bubble" => "#3c8999", "cluster" => "#99843c", "ego" => "#3f993c", "galaxy" => "#993c64", "other" => "#5f3c99"}
    @types = {"Bubbles"=>"bubble", "Clusters"=>"cluster", "EGOs"=>"ego", "Galaxies"=>"galaxy"}
  end

end
