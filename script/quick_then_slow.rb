require 'csv'

# Open writers
CSV.open( Rails.root.to_s+"/data/reduced/quick_slow_output_"+DateTime.now.to_s(:number)+".csv", 'w') do |tag_writer|
tag_writer  << [ "type", "lon", "lat", "rx", "ry", "angle", "qx", "qy", "qrx", "qry", "subject" ]

  # Set parameters
types = ["ego", "cluster", "galaxy"]
threshold_fraction = 0.5
to_process = []
results = []

# Run through images
total = Subject.size
counter = 0
Subject.each do |s|
  counter+=1
  puts "Processing subject #{s.zooniverse_id} (#{counter} of #{total})" if counter%5000==0 && counter>1
  types.each do |o|
    to_process << s.zooniverse_id if s.metadata["markings"] && s.object_count(o) > s.classification_count*threshold_fraction && s.classification_count>=10
  end
end

to_process.uniq!
total = to_process.size
counter = 0
to_process.each do |id|
  s = Subject.find_by_zooniverse_id(id)
  counter+=1
  puts "Processing subject #{s.zooniverse_id} (#{counter} of #{total})" if counter%500==0 && counter>1
  px = s.pixel_scale
  lat = s.glat
  lon = s.glon
  results = s.dbscan

  results.each do |k,h|
    h["reduced"].each do |i|
      tag_writer  << [ k, lon+i["x"]*px, lat+i["y"]*px, i["rx"]*2.0*px, i["ry"]*2.0*px, i["angle"], i["quality"]["qx"], i["quality"]["qy"], i["quality"]["qrx"], i["quality"]["qry"], s.zooniverse_id ]
    end
  end

end

# Close writers
end
