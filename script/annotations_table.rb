Classification.each do |c|
	px = c.subject.pixel_scale
	lat = c.subject.glat
	lon = c.subject.glon
	c.annotations.each{ |a| puts a["name"], lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*px, a["ry"].to_f*px, a["angle"].to_f, c.subject.zooniverse_id }
end