extends VBoxContainer

@onready var main: Control = $"/root/Control"
@onready var cube_editor: VBoxContainer = $FuelCubes/CubeEditor
@onready var patterns: ItemList = $FuelCubes/list/ItemList
@onready var id: LineEdit = $id/ID
@onready var fuel_name: LineEdit = $name/Name
@onready var fuel_icon: OptionButton = $icon/FuelLevel
@onready var fuel_level: SpinBox = $fuelvalue/FuelLevel
@onready var fuel_list: ItemList = $FuelCubes/list/ItemList
@onready var edit: Button = $FuelCubes/list/Edit
@onready var delete: Button = $FuelCubes/list/Delete
@onready var save: Button = $save

var fuel_patterns: Dictionary = {}

func _ready() -> void:
	cube_editor.save_cube.connect(add_pattern)
	delete.pressed.connect(delete_pattern)
	edit.pressed.connect(edit_pattern)
	save.pressed.connect(save_data)
	id.text_changed.connect(savebtntoggle)
	if FileAccess.file_exists(main.filepath+"/recipes_fuel.json"):
		fuel_patterns = JSON.parse_string(FileAccess.open(main.filepath+"/recipes_fuel.json", FileAccess.READ).get_as_text())
		for i in fuel_patterns:
			fuel_list.add_item(i + ": " + fuel_patterns[i]["title"] + ": " + str(fuel_patterns[i]["fuel_value"]), load("res://all_icons/overlay/"+fuel_patterns[i]["icon"]+".png"))
	savebtntoggle("")

func add_pattern(pattern):
	if fuel_name.text != "" && id.text != "" && fuel_level.value != 0 && !fuel_name.text.contains(":"):
		if fuel_patterns.has(id.text):
			fuel_patterns[id.text] = {"title": fuel_name.text, "icon": fuel_icon.text, "cube": pattern, "fuel_value": fuel_level.value}
		else:
			fuel_patterns.get_or_add(id.text, {"title": fuel_name.text, "icon": fuel_icon.text, "cube": pattern, "fuel_value": fuel_level.value})
			fuel_list.add_item(id.text + ": " + fuel_name.text + ": " + str(fuel_level.value), fuel_icon.icon)
		id.editable = true
		fuel_name.editable = true
		fuel_icon.disabled = false
		fuel_level.editable = true

func delete_pattern():
	fuel_patterns.erase(fuel_list.get_item_text(fuel_list.get_selected_items()[0]).get_slice(":", 0))
	fuel_list.remove_item(fuel_list.get_selected_items()[0])

func edit_pattern():
	var pattern: Dictionary = fuel_patterns[fuel_list.get_item_text(fuel_list.get_selected_items()[0]).get_slice(":", 0)]
	id.text = pattern.keys()[0]
	id.editable = false
	fuel_name.text = pattern["title"]
	fuel_name.editable = false
	fuel_icon.text = pattern["icon"]
	fuel_icon.disabled = true
	fuel_level.value = pattern["fuel_value"]
	fuel_level.editable = false
	cube_editor.set_pattern(pattern["cube"])

func savebtntoggle(text: String):
	cube_editor.get_child(3).disabled = text == ""

func save_data():
	var fuel_json = FileAccess.open(main.filepath+"/recipes_fuel.json", FileAccess.WRITE)
	fuel_json.store_string(JSON.stringify(fuel_patterns))
