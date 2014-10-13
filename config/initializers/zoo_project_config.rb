# Project slug in Ouroboros
Milkman::Application.config.project_slug = 		"milky_way"

# Types of annotations
Milkman::Application.config.object_types = [	"bubble",
												"cluster",
												"ego",
												"galaxy",
												"bowshock",
												"pillars",
												"artifact"
											]

Milkman::Application.config.hex = {				"bubble" => "#57D6E4",
												"cluster" => "#D1C056",
												"ego" => "#4FD84E",
												"galaxy" => "#D86593",
												"small-bubble" => "#B894E3",
												"bowshock" => "#F6FF00",
												"pillars" => "#D4B5FF",
												"artifact" => "#FF0700"
									}

Milkman::Application.config.types = {			"Bubble"=>"bubble",
												"Cluster"=>"cluster",
												"EGO"=>"ego",
												"Galaxy"=>"galaxy",
												"Small Bubble"=>"small-bubble",
												"Bow Shock" => "bowshock",
												"Pillars" => "pillars",
												"artifact" => "artifact"
									}
