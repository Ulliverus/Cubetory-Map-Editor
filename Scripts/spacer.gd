extends Button

func _process(_delta: float) -> void:
	if $"../../Tiers".get_child_count() != 0:
		if $"../../Tiers".get_child(0).get_child_count() != 0:
			custom_minimum_size = Vector2($"../../Tiers".get_child(0).get_child(0).size.x, 0)
