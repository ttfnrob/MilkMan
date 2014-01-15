class Subject
  include MongoMapper::Document
  many :classifications
  set_collection_name "milky_way_subjects"
 
  key :project_id, ObjectId
  key :workflow_ids, Array
  key :zooniverse_id, String
  key :state, String

  key :location, Hash
  key :classification_count, Integer
  key :coords, Array

  key :metadata, Hash
  key :size, String

  key :group_id, ObjectId, :optional
  key :group_type, String, :optional
  # timestamps

  scope :near_to, lambda {|centre| where(:id => {'$in' => Subject.near(centre)}) }

  def self.near(centre)
    
    distance = 0.075
    regionals = []
    lows  = Subject.where(:coords => {:$elemMatch => {:$gte => centre[0]-distance, :$gte => centre[1]-distance}}).to_a
    lows.each{|s| regionals<<s if s.coords[0]<=centre[0]+distance && s.coords[1]<=centre[1]+distance } # && s.metadata["size"]=="0.1500x0.0750" }

    subjects = {}
    regionals.each do |s|
      dist = Math.sqrt( ((s.coords[0]-centre[0]) * (s.coords[0]-centre[0])) + ((s.coords[1]-centre[1]) * (s.coords[1]-centre[1])) )
      subjects[s.id] = dist
    end

    subjects.values.sort!
    return subjects.select {|k, v| v < distance}.keys

  end 

  def glat
  	self.coords[0].to_f
  end

  def glon
  	self.coords[1].to_f
  end

  def width
  	self.metadata["size"].split(/x/)[0].to_f
  end

  def height
  	self.metadata["size"].split(/x/)[1].to_f
  end

  def pixel_scale
  	xs = self.width.to_f/800.0
  	ys = self.height.to_f/400.0

  	return xs==ys ? xs : "scale conflict"
  end
  
  def image
    self.location["standard"]
  end

  def object_count(o)
  	self.metadata["markings"] ? self.metadata["markings"][o+"_count"].to_i : 0
  end

  def empty_image?
  	if self.metadata["markings"]
  		if self.object_count("blank")>=5 && self.state=="complete" && self.classification_count<=10
  		  return true
	  	else	
	  	  return false
	    end
    else
	    return false
	end
  end

end  