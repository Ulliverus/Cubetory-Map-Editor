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
@onready var edit: Button = $stampedit/edit
@onready var popup: AcceptDialog = $Warning

var shortcut: Button
var tutorial: Button
enum edit_type {INPUT, OUTPUT, BYPROD}
var editing: edit_type

var stamps: Dictionary = {}

var inputs: Dictionary = {}
var outputs: Dictionary = {}
var byprod: Dictionary = {}

var icons_selectable: Array = []

func _ready() -> void:
	popup.hide()
	recipe_menu.hide()
	cube_editor.hide()
	pack.hide()
	popup.confirmed.connect(resetPopupBtns)
	edit.pressed.connect(edit_recipe)
	popup.custom_action.connect(customPopupReact)
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
	for i in recipe_icon.item_count:
		icons_selectable.append(recipe_icon.get_item_text(i))

func edit_recipe():
	popup.title = "Unnamed Pattern(s)"
	shortcut = popup.add_button("Take me there", true, "openJsonFile")
	tutorial = popup.add_button("Details", false, "tutorial")
	popup.dialog_text = "Some of your pattern's names failed to load.\nThis is most likely due to your savefiles coming from a version that has not yet supported pattern names.\nTo fix this, open the recipes_stamper.json file and add a \"name\" key to each pattern."
	recipe_id.text = recipes.get_item_text(recipes.get_selected_items()[0])
	recipe_name.text = stamps[recipe_id.text]["title"]
	recipe_ticks.value = stamps[recipe_id.text]["ticks"]
	recipe_icon.select(icons_selectable.find(stamps[recipe_id.text]["icon"]))
	for i in stamps[recipe_id.text]["inputs"]:
		if i.has("name"):
			recipe_inputs.add_item(i["name"])
		else:
			recipe_inputs.add_item("Unnamed Pattern")
			popup.show()
	for i in stamps[recipe_id.text]["outputs"]:
		if i.has("name"):
			recipe_outputs.add_item(i["name"])
		else:
			recipe_outputs.add_item("Unnamed Pattern")
			popup.show()
	for i in stamps[recipe_id.text]["byproducts"]:
		if i.has("name"):
			recipe_byproducts.add_item(i["name"])
		else:
			recipe_byproducts.add_item("Unnamed Pattern")
			popup.show()
	byprod_amount.value = stamps[recipe_id.text]["byproduct_count"]
	recipe_id.editable = false
	recipe_name.editable = false
	recipe_ticks.editable = false
	recipe_icon.disabled = true
	recipe_save.disabled = false
	stampedit.hide()
	recipe_menu.show()

func open_recipe_config():
	savebtntoggle("")
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
	if cube_name.text != "":
		match editing:
			edit_type.INPUT:
				extranum.value = floor(extranum.value)
				if inputs.has(cube_name.text):
					inputs[cube_name.text] = {"quantity": extranum.value, "cube": pattern, "name": cube_name.text}
				else:
					inputs.get_or_add(cube_name.text, {"quantity": extranum.value, "cube": pattern, "name": cube_name.text})
				recipe_inputs.add_item(str(extranum.value)+"x "+cube_name.text)
			edit_type.OUTPUT:
				extranum.value = floor(extranum.value)
				if outputs.has(cube_name.text):
					outputs[cube_name.text] = {"quantity": extranum.value, "cube": pattern}
				else:
					outputs.get_or_add(cube_name.text, {"quantity": extranum.value, "cube": pattern})
				recipe_outputs.add_item(str(extranum.value)+"x "+cube_name.text)
			edit_type.BYPROD:
				if byprod.has(cube_name.text):
					byprod[cube_name.text] = {"weight": extranum.value, "cube": pattern}
				else:
					byprod.get_or_add(cube_name.text, {"weight": extranum.value, "cube": pattern})
				recipe_byproducts.add_item(cube_name.text+": "+str(extranum.value*100)+"%")
		cube_name.text = ""
		extranum.value = 1
		cube_editor.hide()
		cube_editor.set_pattern()
		pack.hide()
		recipe_menu.show()
	else:
		popup.title = "Missing Pattern name"
		popup.dialog_text = "Pattern name must be set to allow later edits to this pattern."
		popup.show()

func save_recipe():
	if stamps.has(recipe_id.text):
		stamps[recipe_id.text] = {"title": recipe_name.text,"ticks": recipe_ticks.value,"icon": recipe_icon.text, "inputs": inputs.values(), "outputs": outputs.values(), "byproduct_count": byprod_amount.value, "byproducts": byprod.values()}
	else:
		stamps.get_or_add(recipe_id.text, {"title": recipe_name.text,"ticks": recipe_ticks.value,"icon": recipe_icon.text, "inputs": inputs.values(), "outputs": outputs.values(), "byproduct_count": byprod_amount.value, "byproducts": byprod.values()})
		recipes.add_item(recipe_id.text)
	recipe_id.editable = true
	recipe_name.editable = true
	recipe_id.text = ""
	recipe_name.text = ""
	recipe_ticks.value = 1
	recipe_ticks.editable = true
	recipe_icon.disabled = false
	recipe_icon.select(0)
	recipe_menu.hide()
	stampedit.show()

func save_data():
	var stamper_json = FileAccess.open(main.filepath+"/recipes_stamper.json", FileAccess.WRITE)
	stamper_json.store_string(JSON.stringify(stamps))

func customPopupReact(action: String):
	if action == "openJsonFile":
		OS.shell_open(main.filepath+"/recipes_stamper.json")
	elif action == "tutorial":
		OS.shell_open("https://youtu.be/HFkkK1sCYS4")

func resetPopupBtns():
	popup.remove_button(shortcut)
	popup.remove_button(tutorial)
