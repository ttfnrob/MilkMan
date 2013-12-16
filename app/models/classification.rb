class Classification
  include MongoMapper::Document
  belongs_to :subject
  set_collection_name "milky_way_classifications"

  key :project_id, ObjectId
  key :workflow_id, ObjectId
  key :user_id, ObjectId, :optional
  key :user_name, String, :optional
  key :annotations, Array
  key :subject_ids, Array

  def subject
    Subject.find(subject_ids.first)
  end

  def subject_id
    subject_ids.first
  end

end