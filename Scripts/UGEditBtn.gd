class_name UGEditBtn
extends Button

var pos_in_tree: Vector2i = Vector2i(500,500)

func init(pos):
	pos_in_tree = pos
	pressed.connect(on_press)
	get_parent().get_parent().get_parent().values.get_or_add(pos_in_tree, {"title": "", "description": "", "unlocks": []})
	size_flags_horizontal = 3 #sets container sizing to fill and expand

func on_press():
	get_parent().get_parent().get_parent().open_ug_config(pos_in_tree)
