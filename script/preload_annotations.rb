Subject.where(:state => "complete").where(:cached_annotations => nil).sort(:classification_count.desc).limit(250).each do |i|
  puts "#{i.zooniverse_id}, #{i.classification_count} #{i.annotations.size}"
end
