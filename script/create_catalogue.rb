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
	# PP.pp found_dups if found_dups.size>0
end

CSV.open("milkman-output-#{o}.csv", 'w') do |csv_object|
  csv_object << ["type", "glon", "glat", "degx", "degy", "angle", "qglon", "glat", "qdegx", "qdegy", "potential_duplicate"]
  output.each do |k,list|
  	puts k
  	list.each do |v|
  		this_dup = v["potential_duplicate"] || false
	    csv_object << [ k, v["glon"], v["glat"], v["degx"], v["degy"], v["angle"], v["quality"]["qglon"], v["quality"]["qglat"], v["quality"]["gdegx"], v["quality"]["qdegy"], this_dup ]
	end
  end
end
