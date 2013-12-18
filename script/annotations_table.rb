require 'csv'

objects = ['galaxy', 'ego', 'cluster']

CSV.open( Rails.root.to_s+"/data/galaxy_"+DateTime.now.to_s+".csv", 'w') do |galaxy_writer|
CSV.open( Rails.root.to_s+"/data/ego_"+DateTime.now.to_s+".csv", 'w') do |ego_writer|
CSV.open( Rails.root.to_s+"/data/cluster_"+DateTime.now.to_s+".csv", 'w') do |cluster_writer|


Classification.each do |c|
	px = c.subject.pixel_scale
	lat = c.subject.glat
	lon = c.subject.glon
	if c.try(:annotations)
		c.annotations.each do |a|
			if a["name"]
				galaxy_writer << [ a["name"], lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*px, a["ry"].to_f*px, a["angle"].to_f, c.subject.zooniverse_id ] if a["name"] == "galaxy"
				ego_writer << [ a["name"], lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*px, a["ry"].to_f*px, a["angle"].to_f, c.subject.zooniverse_id ] if a["name"] == "ego"
				cluster_writer << [ a["name"], lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*px, a["ry"].to_f*px, a["angle"].to_f, c.subject.zooniverse_id ] if a["name"] == "cluster"
				if a["name"].in?("bowshock","pillars","artifact","other")
					puts a["name"]
					puts lon+a["left"].to_f*px
					puts lat+(400-a["top"]).to_f*px
					puts a["width"].to_f*px
					puts a["width"].to_f*px
					puts c.subject.zooniverse_id
				end
			end
		end
	end
end

end
end
end