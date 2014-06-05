require "csv"

large = CSV.read('data/legacy/dr1-large.tsv', { :col_sep => "\t" })
large.shift
small = CSV.read('data/legacy/dr1-small.tsv', { :col_sep => "\t" })
small.shift
puts "Files read from data/legacy"

# Remove current DR1 set from DB
CatalogueObject.find_all_by_catalogue_name("DR1").each{|co| co.delete}

large.each do |o|
    abslon = o[2].to_f>180 ? o[2].to_f-360 : o[2].to_f
    CatalogueObject.create(
	  :type => "bubble",
	  :glon => abslon,
	  :glat => o[3].to_f,
	  :degx => o[4].to_f/60.0,
	  :degy => o[5].to_f/60.0,
	  :thickness => o[8].to_f/60.0,
	  :angle => o[10].to_f,
	  :catalogue_name => "DR1",
	  :cat_id => o[0]
	)
end
puts "Large bubbles imported."

small.each do |o|
    abslon = o[2].to_f>180 ? o[2].to_f-360 : o[2].to_f
    CatalogueObject.create(
	  :type => "small-bubble",
	  :glon => abslon,
	  :glat => o[3].to_f,
	  :degx => o[4].to_f/60.0,
	  :degy => o[5].to_f/60.0,
	  :catalogue_name => "DR1",
	  :cat_id => o[0]
	)
end
puts "Small bubbles imported."