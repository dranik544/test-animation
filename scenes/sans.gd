extends AnimatedSprite2D


func playanimdust():
	var mat = material as ShaderMaterial
	var tween = create_tween()
	tween.tween_method(
		func(value): mat.set_shader_parameter("dissolve", value),
		0.0, 1.0, 1.5
	)
