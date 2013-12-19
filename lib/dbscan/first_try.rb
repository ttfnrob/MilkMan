require 'dbscan'
require 'csv'

EPS = 1
MIN_PTS = 3

points = []
object = "galaxy"
file = Dir.glob(Rails.root.to_s+"/data/raw/annotations/"+object+"*.csv").max_by {|f| File.mtime(f)}
puts "Reading in data for type=#{object}"
items=0
CSV.foreach(file, :headers => true) do |row|
  items+=1
  points << [ row["lat"].to_f, row["lon"].to_f, row["rx"].to_f, row["ry"].to_f ] if object.in?('bubble', 'galaxy', 'ego', 'cluster')
  points << [ row["lat"].to_f, row["lon"].to_f, row["width"].to_f, row["height"].to_f ] if object.in?('pillars', 'bowshock', 'artifact', 'other')
end
puts "#{items} items loaded from CSV."

#Run DBSCAN
dbscan = Clusterer.new( points, {:min_points => MIN_PTS, :epsilon => EPS})
puts "DBSCAN initiated, processing..."

puts "Writing data to output file."
CSV.open( Rails.root.to_s+"/data/reduced/dbscan/"+object+"_"+DateTime.now.to_s(:number)+".csv", 'w') do |writer|
	dbscan.results.each do |k, arr|
		unless k==-1
			avlat = arr.transpose[0].inject{|sum, el| sum+el }.to_f/arr.size
			avlon = arr.transpose[1].inject{|sum, el| sum+el }.to_f/arr.size
			avwidth = arr.transpose[2].inject{|sum, el| sum+el }.to_f/arr.size
			avheight = arr.transpose[3].inject{|sum, el| sum+el }.to_f/arr.size
			writer << [avlat, avlon, avwidth, avheight]
		end	
	end
end
puts "DBSCAN complete"

# dbscan.results.each{|k,arr| puts arr.transpose[0].inject{|sum, el| sum+el }.to_f/arr.size if k!=-1}