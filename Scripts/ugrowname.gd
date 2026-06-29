extends HBoxContainer

signal move_up
signal move_down
signal delete

func send_delete() -> void:
	delete.emit()
func send_up() -> void:
	move_up.emit()
func send_down() -> void:
	move_down.emit()
