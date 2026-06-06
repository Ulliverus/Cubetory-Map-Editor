extends VBoxContainer

@onready var main: Control = $"/root/Control"
@onready var maxnum: Label = $MaxResize/Num
@onready var minnum: Label = $MinResize/Num
@onready var minslider: HSlider = $MinResize/Slider
@onready var maxslider: HSlider = $MaxResize/Slider
@onready var name_edit: LineEdit = $Name/LineEdit
@onready var desc_edit: LineEdit = $Description/LineEdit
@onready var sandboxcbx: CheckButton = $Sandbox/checkbox
@onready var save: Button = $save
var values: Dictionary = {"description": "", "max_resize": 2, "min_resize": 0.1, "name": "", "sandbox": true}

func _ready() -> void:
	minslider.value_changed.connect(minvalue_changed)
	maxslider.value_changed.connect(maxvalue_changed)
	save.pressed.connect(save_data)
	if FileAccess.file_exists(main.filepath+"/meta.json"):
		values = JSON.parse_string(FileAccess.open(main.filepath+"/meta.json", FileAccess.READ).get_as_text())
		maxslider.value = values.max_resize
		minslider.value = values.min_resize
		desc_edit.text = values.description
		name_edit.text = values.name
		sandboxcbx.button_pressed = values.sandbox

func minvalue_changed(value: float) -> void:
	minnum.text = str(value)

func maxvalue_changed(value: float) -> void:
	maxnum.text = str(value)

func save_data():
	var meta_json = FileAccess.open(main.filepath+"/meta.json", FileAccess.WRITE)
	values.description = desc_edit.text
	values.name = name_edit.text
	values.max_resize = maxslider.value
	values.min_resize = minslider.value
	values.sandbox = sandboxcbx.button_pressed
	meta_json.store_string(JSON.stringify(values))
