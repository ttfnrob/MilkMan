# Project slug in Ouroboros
Milkman::Application.config.project_slug = 		"milky_way"

# Types of annotations
Milkman::Application.config.object_types = [	"bubble",
												"cluster",
												"ego",
												"galaxy"
											]

Milkman::Application.config.hex = {				"bubble" => "#57D6E4",
												"cluster" => "#D1C056",
												"ego" => "#4FD84E",
												"galaxy" => "#D86593",
												"other" => "#8963DD"
									}

Milkman::Application.config.types = {			"Bubble"=>"bubble",
												"Cluster"=>"cluster",
												"EGO"=>"ego",
												"Galaxy"=>"galaxy"
									}
