extends VBoxContainer

@onready var main: Control = $"/root/Control"
@onready var pit_id: LineEdit = $ID/ID
@onready var pit_name: LineEdit = $Name/Name
@onready var pit_icon: OptionButton = $Icon/Icon
@onready var cube_editor: VBoxContainer = $Pattern/CubeEditor
@onready var edit: Button = $Pattern/list/Edit
@onready var delete: Button = $Pattern/list/Delete
@onready var save: Button = $Save
@onready var pit_list: ItemList = $Pattern/list/ItemList

var pit_patterns: Dictionary = {}

func _ready() -> void:
	cube_editor.save_cube.connect(add_pattern)
	delete.pressed.connect(delete_pattern)
	edit.pressed.connect(edit_pattern)
	save.pressed.connect(save_data)
	pit_id.text_changed.connect(savebtntoggle)
	if FileAccess.file_exists(main.filepath+"/recipes_pit.json"):
		pit_patterns = JSON.parse_string(FileAccess.open(main.filepath+"/recipes_pit.json", FileAccess.READ).get_as_text())
		for i in pit_patterns:
			pit_list.add_item(i + ": " + pit_patterns[i]["title"], load("res://all_icons/no_bg/"+pit_patterns[i]["icon"]+".png"))
	savebtntoggle("")

func add_pattern(pattern):
	if pit_name.text != "" && pit_id.text != "":
		if pit_patterns.has(pit_id.text):
			pit_patterns[pit_id.text] = {"title": pit_name.text, "icon": pit_icon.text, "input": {"quantity": 1, "cube":pattern}, "output": pit_icon.text}
		else:
			pit_patterns.get_or_add(pit_id.text, {"title": pit_name.text, "icon": pit_icon.text, "input": {"quantity": 1, "cube":pattern}, "output": pit_icon.text})
			pit_list.add_item(pit_id.text+": "+pit_name.text, pit_icon.icon)
		pit_id.editable = true
		pit_name.editable = true
		pit_icon.disabled = false

func delete_pattern():
	pit_patterns.erase(pit_list.get_item_text(pit_list.get_selected_items()[0]).get_slice(":", 0))
	pit_list.remove_item(pit_list.get_selected_items()[0])

func savebtntoggle(text: String):
	cube_editor.get_child(3).disabled = text == ""

func edit_pattern():
	var pattern: Dictionary = pit_patterns[pit_list.get_item_text(pit_list.get_selected_items()[0]).get_slice(":", 0)]
	pit_id.text = pit_patterns.find_key(pattern)
	savebtntoggle(pit_patterns.find_key(pattern))
	pit_id.editable = false
	pit_name.text = pattern["title"]
	pit_name.editable = false
	pit_icon.text = pattern["icon"]
	pit_icon.icon = pit_list.get_item_icon(pit_list.get_selected_items()[0])
	pit_icon.disabled = true
	cube_editor.set_pattern(pattern["input"]["cube"])

func save_data():
	var pit_json = FileAccess.open(main.filepath+"/recipes_pit.json", FileAccess.WRITE)
	pit_json.store_string(JSON.stringify(pit_patterns))
