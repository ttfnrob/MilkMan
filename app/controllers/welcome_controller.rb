
class WelcomeController < ApplicationController
  def index
    @pagetitle = "Milkman"

    @presubjects = []
    @newsubjects = []
    @presubjects = Subject.where(:state => "complete").where(:zooniverse_id.ne => "AMW0000v75").where(:cached_annotations.ne => nil).sort(:classification_count.desc).limit(12)
    @newsubjects = Subject.where(:state => "complete").where(:zooniverse_id.ne => "AMW0000v75").where(:cached_annotations => nil).sort(:classification_count.desc).limit(12)

    if Subject.where(:state => "complete").where(:zooniverse_id.ne => "AMW0000v75").where(:cached_annotations.ne => nil).size < 50
      Subject.where(:state => "complete").where(:cached_annotations => nil).sort(:classification_count.desc).limit(6).each do |i|
        puts "#{i.zooniverse_id}, #{i.classification_count} #{i.annotations.size}"
      end
    end
  end
end
