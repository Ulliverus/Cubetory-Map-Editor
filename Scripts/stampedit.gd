extends Control

@onready var main: Control = $"/root/Control"

@onready var stampedit: VBoxContainer = $stampedit
@onready var recipe_menu: VBoxContainer = $RecipeMenu
@onready var cube_editor: VBoxContainer = $CubeEditor
@onready var add: Button = $stampedit/add
@onready var recipes: ItemList = $stampedit/Recipes
@onready var save_all: Button = $stampedit/save

@onready var recipe_id: LineEdit = $RecipeMenu/ID/ID
@onready var recipe_name: LineEdit = $RecipeMenu/Title/Name
@onready var recipe_ticks: SpinBox = $RecipeMenu/Ticks/Ticks
@onready var recipe_icon: OptionButton = $RecipeMenu/Icon/Icon
@onready var recipe_save: Button = $RecipeMenu/save
@onready var recipe_inputs: ItemList = $RecipeMenu/RecipeConfig/input/Inputs
@onready var add_input: Button = $RecipeMenu/RecipeConfig/input/AddInput
@onready var recipe_outputs: ItemList = $RecipeMenu/RecipeConfig/output/Outputs
@onready var recipe_byproducts: ItemList = $RecipeMenu/RecipeConfig/output/Byproducts
@onready var add_output: Button = $RecipeMenu/RecipeConfig/output/AddOutput
@onready var add_byproduct: Button = $RecipeMenu/RecipeConfig/output/byprod/AddByproduct
@onready var byprod_amount: SpinBox = $RecipeMenu/RecipeConfig/output/byprod/Amount
@onready var extranum: SpinBox = $CubeEditor/num
@onready var cube_name: LineEdit = $CubeEditor/name
@onready var pack: VBoxContainer = $pack
@onready var packedcube: HBoxContainer = $pack/packedcube
@onready var pextranum: SpinBox = $pack/num
@onready var pcubename: LineEdit = $pack/name

enum edit_type {INPUT, OUTPUT, BYPROD}
var editing: edit_type

var stamps: Dictionary = {}

var inputs: Array = []
var outputs: Array = []
var byprod: Array = []

func _ready() -> void:
	recipe_menu.hide()
	cube_editor.hide()
	pack.hide()
	recipe_id.text_changed.connect(savebtntoggle)
	add.pressed.connect(open_recipe_config)
	cube_editor.save_cube.connect(save_pattern)
	packedcube.save_cube.connect(save_pattern)
	save_all.pressed.connect(save_data)
	recipe_save.pressed.connect(save_recipe)
	add_input.pressed.connect(open_input_config)
	add_output.pressed.connect(open_output_config)
	add_byproduct.pressed.connect(open_byprod_config)
	pextranum.value_changed.connect(numparity)
	pcubename.text_changed.connect(nameparity)
	if FileAccess.file_exists(main.filepath+"/recipes_stamper.json"):
		stamps = JSON.parse_string(FileAccess.open(main.filepath+"/recipes_stamper.json", FileAccess.READ).get_as_text())
		for i in stamps.keys():
			recipes.add_item(i)

func open_recipe_config():
	recipe_menu.show()
	stampedit.hide()

func open_input_config():
	editing = edit_type.INPUT
	extranum.min_value = 1
	extranum.max_value = 100
	extranum.prefix = "Amount: "
	extranum.step = 1
	pextranum.min_value = 1
	pextranum.max_value = 100
	pextranum.prefix = "Amount: "
	pextranum.step = 1
	if Input.is_action_pressed("shift"):
		pack.show()
		recipe_menu.hide()
	else:
		cube_editor.show()
		cube_editor.can_random = false
		recipe_menu.hide()

func open_output_config():
	editing = edit_type.OUTPUT
	extranum.min_value = 1
	extranum.max_value = 100
	extranum.prefix = "Amount: "
	extranum.step = 1
	pextranum.min_value = 1
	pextranum.max_value = 100
	pextranum.prefix = "Amount: "
	pextranum.step = 1
	if Input.is_action_pressed("shift"):
		pack.show()
		recipe_menu.hide()
	else:
		cube_editor.show()
		cube_editor.can_random = true
		recipe_menu.hide()

func open_byprod_config():
	editing = edit_type.BYPROD
	extranum.min_value = 0
	extranum.max_value = 1
	extranum.prefix = "Weight: "
	extranum.step = 0.01
	pextranum.min_value = 0
	pextranum.max_value = 1
	pextranum.prefix = "Weight: "
	pextranum.step = 0.01
	if Input.is_action_pressed("shift"):
		pack.show()
		recipe_menu.hide()
	else:
		cube_editor.show()
		cube_editor.can_random = true
		recipe_menu.hide()

func nameparity(text: String):
	cube_name.text = text
func numparity(num: float):
	extranum.value = num

func savebtntoggle(text: String):
	recipe_save.disabled = text == ""

func save_pattern(pattern):
	match editing:
		edit_type.INPUT:
			extranum.value = floor(extranum.value)
			inputs.append({"quantity": extranum.value, "cube": pattern})
			recipe_inputs.add_item(str(extranum.value)+"x "+cube_name.text)
		edit_type.OUTPUT:
			extranum.value = floor(extranum.value)
			outputs.append({"quantity": extranum.value, "cube": pattern})
			recipe_outputs.add_item(str(extranum.value)+"x "+cube_name.text)
		edit_type.BYPROD:
			byprod.append({"weight": extranum.value, "cube": pattern})
			recipe_byproducts.add_item(cube_name.text+": "+str(extranum.value+100)+"%")
	cube_name.text = ""
	extranum.value = 1
	cube_editor.hide()
	pack.hide()
	recipe_menu.show()

func save_recipe():
	stamps.get_or_add(recipe_id.text, {"title": recipe_name.text,"ticks": recipe_ticks.value,"icon": recipe_icon.text, "inputs": inputs, "outputs": outputs, "byproduct_count": byprod_amount.value, "byproducts": byprod})
	recipes.add_item(recipe_id.text)
	recipe_menu.hide()
	stampedit.show()

func save_data():
	var stamper_json = FileAccess.open(main.filepath+"/recipes_stamper.json", FileAccess.WRITE)
	stamper_json.store_string(JSON.stringify(stamps))
