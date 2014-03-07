
class WelcomeController < ApplicationController
  def index
    @pagetitle = "Milkman"
    @presubjects = Subject.where(:state => "complete").where(:zooniverse_id.ne => "AMW0000v75").where(:cached_annotations.ne => nil).sort(:classification_count.desc).limit(18)
    @newsubjects = Subject.where(:state => "complete").where(:zooniverse_id.ne => "AMW0000v75").where(:cached_annotations => nil).sort(:classification_count.desc).limit(6)
  end
end
