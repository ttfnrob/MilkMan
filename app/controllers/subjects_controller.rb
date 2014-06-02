class SubjectsController < ApplicationController
  def index
  end

  def show
    @s = Subject.find_by_zooniverse_id(params[:zoo_id])
    @pagetitle = "Milkman"
    @results = @s.cache_scan_result
    @simbad_gal = @s.simbad_gal_list
    @simbad = @s.simbad_for_svg
  end

  def preview
    width = 400
    height = 200
    @s = Subject.find_by_zooniverse_id(params[:zoo_id])
    @results = @s.cache_scan_result
    render :layout => false
  end

  def coordinates
    @pagetitle = "Milkman"
    @subjects = Subject.find_in_range(params[:lon].to_f, params[:lat].to_f)
  end

  def simbad
    @s = Subject.find_by_zooniverse_id(params[:zoo_id])
    @pagetitle = "Milkman"
    @simbad = @s.simbad_for_svg
    puts @simbad
    render :layout => false
  end

  def raw
    @s = Subject.find_by_zooniverse_id(params[:zoo_id])
    @raw = @s.annotations
    @pagetitle = "Milkman"
    render :layout => false
  end

end
