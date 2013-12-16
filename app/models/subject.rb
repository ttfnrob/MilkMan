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

  def glat
  	self.coords[0].to_f
  end

  def glon
  	self.coords[1]
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