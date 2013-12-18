$:.unshift File.dirname($0)
require 'subclu'
require 'csv'

EPS = 0.02
MIN_PTS = 2

db = [
		[0.0,0.1,0.2,0.3],
		[0.0,0.1,0.2,0.41],
		[0.0,0.1,0.2,0.42],
		[0.0,0.1,0.2,0.43],
		[0.0,0.1,0.2,0.44],
		[0.5,0.1,0.2,0.45],
		[0.5,0.1,0.2,0.46],
		[0.5,0.1,0.2,0.47],
		[0.5,0.1,0.2,0.48],
		[0.5,0.1,0.2,0.49],
		[0.5,0.1,0.2,0.50],
		[0.5,0.1,0.2,0.51],
		[0.5,0.1,0.2,0.52]
	]

db = []
object = "bowshock"
file = Dir.glob(Rails.root.to_s+"/data/raw/annotations/"+object+"*.csv").max_by {|f| File.mtime(f)}
puts "Reading in data for type=#{object}"
CSV.foreach(file, :headers => true) do |row|
  db << [ row["lat"], row["lon"], row["rx"], row["ry"] ] if object.in?('bubble', 'galaxy', 'ego', 'cluster')
  db << [ row["lat"], row["lon"] ] if object.in?('pillars', 'bowshock', 'artifact', 'other')
end
puts "Data loaded from CSV."

#dbscan runs on all attributes
all_attribute_indices = db[0].index
dbscan = DBscan.new(EuclideanDistance.new(all_attribute_indices))
puts "DBSCAN initiated, processing..."
result = dbscan.run(db, EPS, MIN_PTS)

# #test run of subclu, which outputs all possibilities for projected clustering
# subclu = SUBCLU.new(JensenShannonDistance)
# result = subclu.run(db, EPS, MIN_PTS)

puts "Writing data to output file."
CSV.open( Rails.root.to_s+"/data/reduced/dbscan/"+object+"_"+DateTime.now.to_s(:number)+".csv", 'w') do |writer|
	result.each_index do |dim|
		result[4].each_pair do |subspace, clusters|
			# puts "		#{subspace.inspect}"
			clusters.each do |cluster|
					writer << cluster
				# puts "			#{cluster}"
			end		
		end
	end
end
puts "DBSCAN omplete"

