
class WelcomeController < ApplicationController
  def index
    @pagetitle = "Milkman"

    @presubjects = []
    @newsubjects = []
    @presubjects = Subject.where(:state => "complete").where(:zooniverse_id.ne => "AMW0000v75").where(:cached_annotations.ne => nil).sort(:classification_count.desc).limit(12)
    @newsubjects = Subject.where(:state => "complete").where(:zooniverse_id.ne => "AMW0000v75").where(:cached_annotations => nil).sort(:classification_count.desc).limit(12)

    Subject.preload if Subject.where(:state => "complete").where(:zooniverse_id.ne => "AMW0000v75").where(:cached_annotations.ne => nil).size < 50
  end
end
