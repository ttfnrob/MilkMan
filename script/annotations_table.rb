require 'csv'

objects = ['galaxy', 'ego', 'cluster']

CSV.open( Rails.root.to_s+"/data/raw/annotations/bubble_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |bubble_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/galaxy_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |galaxy_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/ego_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |ego_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/cluster_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |cluster_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/bowshock_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |bowshock_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/pillars_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |pillars_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/artifact_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |artifact_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/other_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |other_writer|

bubble_writer << [ "type", "lon", "lat", "rx", "ry", "angle", "zooniverse_id", "user_name", "user_ip", "created_at" ]
galaxy_writer << [ "type", "lon", "lat", "rx", "ry", "angle", "zooniverse_id", "user_name", "user_ip", "created_at" ]
ego_writer << [ "type", "lon", "lat", "rx", "ry", "angle", "zooniverse_id", "user_name", "user_ip", "created_at" ]
cluster_writer << [ "type", "lon", "lat", "rx", "ry", "angle", "zooniverse_id", "user_name", "user_ip", "created_at" ]
bowshock_writer << [ "type", "lon", "lat", "width", "height", "zooniverse_id", "user_name", "user_ip", "created_at" ]
pillars_writer << [ "type", "lon", "lat", "width", "height", "zooniverse_id", "user_name", "user_ip", "created_at" ]
artifact_writer << [ "type", "lon", "lat", "width", "height", "zooniverse_id", "user_name", "user_ip", "created_at" ]
other_writer << [ "type", "lon", "lat", "width", "height", "zooniverse_id", "user_name", "user_ip", "created_at" ]

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
				bubble_writer << [ a["name"], lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*px, a["ry"].to_f*px, a["angle"].to_f, c.subject.zooniverse_id, c.user_name, c.user_ip, c.created_at ] if a["name"] == "bubble"
				galaxy_writer << [ a["name"], lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*px, a["ry"].to_f*px, a["angle"].to_f, c.subject.zooniverse_id, c.user_name, c.user_ip, c.created_at ] if a["name"] == "galaxy"
				ego_writer << [ a["name"], lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*px, a["ry"].to_f*px, a["angle"].to_f, c.subject.zooniverse_id, c.user_name, c.user_ip, c.created_at ] if a["name"] == "ego"
				cluster_writer << [ a["name"], lon+a["center"][0].to_f*px, lat+a["center"][1].to_f*px, a["rx"].to_f*px, a["ry"].to_f*px, a["angle"].to_f, c.subject.zooniverse_id, c.user_name, c.user_ip, c.created_at ] if a["name"] == "cluster"
				
				if a["name"] == "object"
					bowshock_writer << [ a["content"], lon+a["left"].to_f*px, lat+(400.0-a["top"].to_f).to_f*px, a["width"].to_f*px, a["height"].to_f*px, c.subject.zooniverse_id, c.user_name, c.user_ip, c.created_at ] if a["content"] == "bowshock"
					pillars_writer << [ a["content"], lon+a["left"].to_f*px, lat+(400.0-a["top"].to_f).to_f*px, a["width"].to_f*px, a["height"].to_f*px, c.subject.zooniverse_id, c.user_name, c.user_ip, c.created_at ] if a["content"] == "pillars"
					artifact_writer << [ a["content"], lon+a["left"].to_f*px, lat+(400.0-a["top"].to_f).to_f*px, a["width"].to_f*px, a["height"].to_f*px, c.subject.zooniverse_id, c.user_name, c.user_ip, c.created_at ] if a["content"] == "artifact"
					other_writer << [ a["content"], lon+a["left"].to_f*px, lat+(400.0-a["top"].to_f).to_f*px, a["width"].to_f*px, a["height"].to_f*px, c.subject.zooniverse_id, c.user_name, c.user_ip, c.created_at ] if a["content"] == "other"
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
