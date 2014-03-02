require 'csv'

CSV.open( Rails.root.to_s+"/data/raw/annotations/bubble_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |bubble_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/galaxy_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |galaxy_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/ego_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |ego_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/cluster_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |cluster_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/bowshock_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |bowshock_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/pillars_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |pillars_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/artifact_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |artifact_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/other_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |other_writer|

bubble_writer << [ "lon", "lat", "rx", "ry", "angle" ]
galaxy_writer << [ "lon", "lat", "rx", "ry", "angle" ]
ego_writer << [ "lon", "lat", "rx", "ry", "angle" ]
cluster_writer << [ "lon", "lat", "rx", "ry", "angle" ]
bowshock_writer << [ "lon", "lat", "width", "height" ]
pillars_writer << [ "lon", "lat", "width", "height" ]
artifact_writer << [ "lon", "lat", "width", "height" ]
other_writer << [ "lon", "lat", "width", "height" ]

total = Classification.size
counter = 0
Classification.each do |c|
	counter+=1
	puts "Processing classification #{counter} or #{total}" if counter%1000==0 && counter>1
	px = c.subject.pixel_scale
	lat = c.subject.glat
	lon = c.subject.glon
	if c.try(:annotations)
		c.annotations.each do |a|
			# puts a
			if a["name"]
				bubble_writer << [ lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*2.0*px, a["ry"].to_f*2.0*px, a["angle"].to_f ] if a["name"] == "bubble" && a["rx"].to_f > 0 && a["ry"].to_f > 0
				galaxy_writer << [ lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*2.0*px, a["ry"].to_f*2.0*px, a["angle"].to_f ] if a["name"] == "galaxy" && a["rx"].to_f > 0 && a["ry"].to_f > 0
				ego_writer << [ lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*2.0*px, a["ry"].to_f*2.0*px, a["angle"].to_f ] if a["name"] == "ego" && a["rx"].to_f > 0 && a["ry"].to_f > 0
				cluster_writer << [ lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*2.0*px, a["ry"].to_f*2.0*px, a["angle"].to_f ] if a["name"] == "cluster" && a["rx"].to_f > 0 && a["ry"].to_f > 0
				
				if a["name"] == "object"
					bowshock_writer << [ lon+a["left"].to_f*px, lat+(400.0-a["top"].to_f).to_f*px, a["width"].to_f*px, a["height"].to_f*px ] if a["content"] == "bowshock" && a["width"].to_f > 0 && a["width"].to_f > 0
					pillars_writer << [ lon+a["left"].to_f*px, lat+(400.0-a["top"].to_f).to_f*px, a["width"].to_f*px, a["height"].to_f*px ] if a["content"] == "pillars" && a["width"].to_f > 0 && a["width"].to_f > 0
					artifact_writer << [ lon+a["left"].to_f*px, lat+(400.0-a["top"].to_f).to_f*px, a["width"].to_f*px, a["height"].to_f*px ] if a["content"] == "artifact" && a["width"].to_f > 0 && a["width"].to_f > 0
					other_writer << [ lon+a["left"].to_f*px, lat+(400.0-a["top"].to_f).to_f*px, a["width"].to_f*px, a["height"].to_f*px ] if a["content"] == "other" && a["width"].to_f > 0 && a["width"].to_f > 0
				end
			end
		end
	end
end

end
end
end
end

end
end
end
end
