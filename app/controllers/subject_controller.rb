class SubjectsController < ApplicationController
  
  def show
    subject = project.named(:subject).where(zooniverse_id: params[:id]).first
    
    if subject
      render json: subject, location: project_subject_path(project.name, subject)
    else
      render json: { }, status: 404
    end
  end
  
  def index
    render json: project.subjects.next_subject(subject_selector_params)
  end

  def list_blank_images
    blanks = Subject.each{|s| s.image if s.empty_image?}
    render json: blanks
  end

  def list_object_images(o,threshold_fraction)
    Subject.each{|s| puts "#{s.zooniverse_id}, #{s.image}, #{s.glat}, #{s.glon}, #{s.classification_count}, #{s.object_count(o)}, #{s.object_count(o).to_f/s.classification_count.to_f}" if s.metadata["markings"] && s.object_count(o) > s.classification_count*threshold_fraction && s.classification_count>=10}
    list = Subject.each{|s| s.image if s.metadata["markings"] && s.object_count(o) > s.classification_count*threshold_fraction}
    render json: list
  end

end