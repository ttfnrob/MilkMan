require 'pp'

def same_object(o1, o2, duphash, tolerance=0.05)
	same = {}
	if o1.keys.size == o2.keys.size
		duphash.keys.each do |k|
			unless o1[k].is_a?(Hash) || o2[k].is_a?(Hash)
				same[k] = ((o1[k].to_f - o2[k].to_f).abs <= duphash[k]) ? same[k] = true : same[k] = false
			end
		end
	end
	return same.has_value?(false) ? false : true
end

o="all" 			# type to use or "all"
lons = [0,360] 	#longitude range
lats = [-5,5] 		#latitude range

output = {}
ScanResult.all.each do |r|
	r.annotations.map do |drawtype,data|
		data.map do |datatype,objects|
			if drawtype==o || o=="all" #only process what is needed
				if datatype=="reduced" #only use reduced data
					objects.each do |o|
						o["zooniverse_id"] = r["zooniverse_id"]
						o["image_url"] = Subject.find_by_zooniverse_id(r["zooniverse_id"]).image
						o["pixel_scale"] = Subject.find_by_zooniverse_id(r["zooniverse_id"]).pixel_scale
						if o["glon"] >= lons[0] && o["glon"] <= lons[1] && o["glat"] >= lats[0] && o["glat"] <= lats[1] # only save data in spatial range
							defined?(output[drawtype].first) ? output[drawtype] << o : output[drawtype] = [o]
						end
					end
				end
			end
		end
	end
end

puts "Done:"
output.each{|k,a| puts "#{a.size} #{k} objects"}

duphash = {"glat" => 0.001, "glon" => 0.001, "degx" => 0.005, "degy" => 0.005, "angle" => 15}

output.each do |k,v|
	puts "Duplicate checking #{k}"
	found_dups = {}
	v.each_with_index do |o1, i|
		v.each_with_index do |o2, j|
			if (o1!=o2) && (i>j) && (same_object(o1, o2, duphash) == true)
				defined?(found_dups[i].first) ? found_dups[i] << o1 : found_dups[i] = [o1]
				found_dups[i] << o2
				o2['potential_duplicate'] = true
			end
		end
	end
end

# Clear out current DB table of DR2 results
CatalogueObject.find_all_by_catalogue_name("DR2").each{|co| co.delete}

# Write to CSV file and to DB
CSV.open("public/milkman-output-#{o}.csv", 'w') do |csv_object|
  csv_object << ["type", "glon", "glat", "degx", "degy", "imgx", "imgy", "rx", "ry", "angle", "qglon", "gqlat", "qdegx", "qdegy", "potential_duplicate", "pixel_scale", "zooniverse_id", "img_url", "cat_id"]
  output.each do |k,list|
  	puts k
  	list.each do |o|
  		
  		# Create specific/custom catalogue entries
  		this_dup = o["potential_duplicate"] || false
  		abslon = o["glon"]>180 ? o["glon"]-360 : o["glon"]
  		pm = o["glat"]<0 ? "-" : "+"
  		plon = sprintf '%.3f', o["glon"] # Because .round() doesn't to trailing zeros
  		plat = sprintf '%.3f', o["glat"]
  		sup = k=='bowshock' ? k[0].capitalize+'W' : k[0].capitalize
  		cat_id = "MWP2G"+plon.to_s.sub(/\./, '').rjust(6, "0") + pm + plat.to_s.sub(/\./, '').sub(/\-/, '').rjust(6, "0")+sup

	    # Add to CSV file
	    csv_object << [ k, abslon, o["glat"], o["degx"], o["degy"], o["x"], o["y"], o["rx"], o["ry"], o["angle"], o["quality"]["qglon"], o["quality"]["qglat"], o["quality"]["gdegx"], o["quality"]["qdegy"], this_dup, o["pixel_scale"], o["zooniverse_id"], o["image_url"], cat_id ]
	    
	    # Add to DB
	    CatalogueObject.create(
	    	  :type => k,
			  :glon => abslon,
			  :glat => o["glat"],
			  :degx => o["degx"],
			  :degy => o["degy"],
			  :imgx => o["x"],
			  :imgy => o["y"],
			  :rx => o["rx"],
			  :ry => o["ry"],
			  :angle => o["angle"],
			  :qglon => o["quality"]["qglon"],
			  :gqlat => o["quality"]["qglat"],
			  :qdegx => o["quality"]["gdegx"],
			  :qdegy => o["quality"]["qdegy"],
			  :potential_duplicate => this_dup,
			  :pixel_scale => o["pixel_scale"],
			  :zooniverse_id => o["zooniverse_id"],
			  :img_url => o["image_url"],
			  :catalogue_name => "DR2",
			  :cat_id => cat_id
	    )
	end
  end
end
