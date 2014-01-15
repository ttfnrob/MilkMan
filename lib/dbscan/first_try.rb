require 'dbscan'
require 'csv'

def closest_image
	# Subject.find
end

EPS = 0.002
MIN_PTS = 5

points = []
object = "galaxy"
file = Dir.glob(Rails.root.to_s+"/data/raw/annotations/"+object+"*.csv").max_by {|f| File.mtime(f)}
puts "Reading in data for type=#{object}"
items=0

# lonr = [267.0,280.0]
# latr = [-0.5,+0.5]

lonr = [0.0,10.0]
latr = [2.0,3.0]

CSV.foreach(file, :headers => true) do |row|
  
  l = row["lon"].to_f
  b = row["lat"].to_f
  s = Math.sqrt(row["rx"].to_f*row["rx"].to_f + row["ry"].to_f*row["ry"].to_f) if object.in?('bubble', 'galaxy', 'ego', 'cluster')
  s = Math.sqrt(row["width"].to_f*row["width"].to_f + row["height"].to_f*row["height"].to_f) if object.in?('pillars', 'bowshock', 'artifact', 'other')

  if b > latr[0] && b < latr[1] && l > lonr[0] && l < lonr[1]
	  items+=1
	  points << [ b, l, s ]
  end

end
puts "#{items} items loaded from CSV."

#Run DBSCAN
dbscan = Clusterer.new( points, {:min_points => MIN_PTS, :epsilon => EPS})
puts "DBSCAN initiated, processing..."

puts "Writing data to output file."
CSV.open( Rails.root.to_s+"/data/reduced/dbscan/"+object+"_"+DateTime.now.to_s(:number)+".csv", 'w') do |writer|
	writer << ["glon", "glat", "size", "count"]
	dbscan.results.each do |k, arr|
		unless k==-1
			avlat = arr.transpose[0].inject{|sum, el| sum+el }.to_f/arr.size
			avlon = arr.transpose[1].inject{|sum, el| sum+el }.to_f/arr.size
			avsize = arr.transpose[2].inject{|sum, el| sum+el }.to_f/arr.size
			s = Subject.near_to([avlat.to_f,avlon.to_f]).first
			
			begin
				img_url = s.location["standard"]
				zooid = s.zooniverse_id
			rescue
				img_url = ""
				zooid = ""
			end
			# avheight = arr.transpose[3].inject{|sum, el| sum+el }.to_f/arr.size
			puts "#{avlon} #{avlat} #{avsize} #{arr.size} #{img_url}, #{zooid}"
			writer << [avlon, avlat, avsize, arr.size, img_url, zooid]
		end	
	end
end
puts "DBSCAN complete"

# dbscan.results.each{|k,arr| puts arr.transpose[0].inject{|sum, el| sum+el }.to_f/arr.size if k!=-1}