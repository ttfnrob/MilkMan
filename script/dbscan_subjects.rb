require 'csv'

CSV.open( Rails.root.to_s+"/data/raw/annotations/bubble_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |bubble_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/galaxy_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |galaxy_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/ego_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |ego_writer|
CSV.open( Rails.root.to_s+"/data/raw/annotations/cluster_raw_"+DateTime.now.to_s(:number)+".csv", 'w') do |cluster_writer|

bubble_writer  << [ "lon", "lat", "rx", "ry", "angle", "qx", "qy", "qrx", "qry", "subject" ]
galaxy_writer  << [ "lon", "lat", "rx", "ry", "angle", "qx", "qy", "qrx", "qry", "subject" ]
ego_writer     << [ "lon", "lat", "rx", "ry", "angle", "qx", "qy", "qrx", "qry", "subject" ]
cluster_writer << [ "lon", "lat", "rx", "ry", "angle", "qx", "qy", "qrx", "qry", "subject" ]

total = Subject.size
counter = 0
Subject.each do |s|
  counter+=1
  puts "Processing subject #{s.zooniverse_id} (#{counter} of #{total})" if counter%100==0 && counter>1
  px = s.pixel_scale
  lat = s.glat
  lon = s.glon
  results = s.dbscan

  results["bubble"]["reduced"].each do |i|
    bubble_writer  << [ lon+i["x"]*px, lat+i["y"]*px, i["rx"]*2.0*px, i["ry"]*2.0*px, i["angle"], i["quality"]["qx"], i["quality"]["qy"], i["quality"]["qrx"], i["quality"]["qry"], s.zooniverse_id ]
  end

  results["cluster"]["reduced"].each do |i|
    cluster_writer << [ lon+i["x"]*px, lat+i["y"]*px, i["rx"]*2.0*px, i["ry"]*2.0*px, i["angle"], i["quality"]["qx"], i["quality"]["qy"], i["quality"]["qrx"], i["quality"]["qry"], s.zooniverse_id ]
  end

  results["ego"]["reduced"].each do |i|
    ego_writer << [ lon+i["x"]*px, lat+i["y"]*px, i["rx"]*2.0*px, i["ry"]*2.0*px, i["angle"], i["quality"]["qx"], i["quality"]["qy"], i["quality"]["qrx"], i["quality"]["qry"], s.zooniverse_id ]
  end

  results["galaxy"]["reduced"].each do |i|
    galaxy_writer << [ lon+i["x"]*px, lat+i["y"]*px, i["rx"]*2.0*px, i["ry"]*2.0*px, i["angle"], i["quality"]["qx"], i["quality"]["qy"], i["quality"]["qrx"], i["quality"]["qry"], s.zooniverse_id ]
  end

end

end
end
end
end
