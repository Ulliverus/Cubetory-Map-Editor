extends VBoxContainer

@onready var main: Control = $"/root/Control"

@onready var terrainsettings: HBoxContainer = $terrainsettings
@onready var t_name: LineEdit = $terrainsettings/name
@onready var type_select: OptionButton = $terrainsettings/TypeSelect
@onready var color_select: OptionButton = $terrainsettings/ColorSelect
@onready var set_yield: Button = $terrainsettings/SetYield
@onready var biome_select: OptionButton = $terrainsettings/BiomeSelect
@onready var label: Label = $terrainsettings/Specific
@onready var image: Button = $TextureRect
@onready var oreyieldmenu: HBoxContainer = $Oreyield
@onready var oreyieldlist: ItemList = $Oreyield/yield
@onready var btns: HBoxContainer = $Btns
@onready var weight: SpinBox = $Oreyield/CubeEditor/weight
@onready var patternname: LineEdit = $Oreyield/CubeEditor/patternname
@onready var list: ItemList = $Btns/List

var terrain: Dictionary = {}
var geysertype: String
const geyserstr = {3: "Basic", 4: "Shallow", 5: "Splash", 6: "Deep", 7: "Donut", 8: "SideSplash"}

enum Feature {
	None,
	OreBlank,
	Spawn,
	ForceNone,
	#for old savefiles
	StarterGeyserRed,
	StarterGeyserYellow,
	StarterGeyserBlue,
	
	ShallowGeyserRed,
	ShallowGeyserYellow,
	ShallowGeyserBlue,
	ShallowGeyserOrange,
	ShallowGeyserGreen,
	ShallowGeyserPurple,
	
	BasicGeyserRed,
	BasicGeyserYellow,
	BasicGeyserBlue,
	BasicGeyserOrange,
	BasicGeyserGreen,
	BasicGeyserPurple,
	
	SplashGeyserRed,
	SplashGeyserYellow,
	SplashGeyserBlue,
	SplashGeyserGreen,
	SplashGeyserPurple,
	SplashGeyserOrange,
	
	DeepGeyserBlue,
	DeepGeyserRed,
	DeepGeyserYellow,
	DeepGeyserOrange,
	DeepGeyserPurple,
	DeepGeyserGreen,
	
	Garbage,
	
	DonutGeyserBlue,
	DonutGeyserRed,
	DonutGeyserYellow,
	DonutGeyserGreen,
	DonutGeyserPurple,
	DonutGeyserOrange,
	DonutGeyserBrown,
	
	SideSplashGeyserBlue,
	SideSplashGeyserRed,
	SideSplashGeyserYellow,
	SideSplashGeyserGreen,
	SideSplashGeyserPurple,
	SideSplashGeyserOrange,
	SideSplashGeyserBrown,
	#browns that bro forgor in original build
	BasicGeyserBrown,
	ShallowGeyserBrown,
	DeepGeyserBrown,
	SplashGeyserBrown}

var t: String
var oreyield: Array = []
var feature: int

func _ready() -> void:
	set_yield.hide()
	label.hide()
	color_select.hide()
	oreyieldmenu.hide()
	if FileAccess.file_exists(main.filepath+"/terrain.bkp"):
		terrain = FileAccess.open(main.filepath+"/terrain.bkp", FileAccess.READ).get_var()
		for i in terrain.keys():
			list.add_item(i)


func set_edit_type(index: int) -> void:
	$TextureRect/Label.hide()
	match index:
		0:
			set_yield.hide()
			color_select.hide()
			label.hide()
			image.icon = load("res://terrain/empty.png")
			t = "empty"
			feature = 0
		1:
			set_yield.hide()
			color_select.hide()
			label.hide()
			image.icon = load("res://terrain/garbage.png")
			t = "feature"
			feature = 31
		2:
			set_yield.show()
			color_select.hide()
			label.show()
			label.text = "Yield:    "
			image.icon = load("res://terrain/ore.png")
			t = "ore"
		3, 4, 5, 6, 7, 8:
			set_yield.hide()
			color_select.show()
			label.show()
			label.text = "Color:   "
			image.icon = null
			geysertype = geyserstr[index]
			t = "feature"
	set_color(color_select.get_selected_id())

func set_color(index: int) -> void:
	image.icon = load("res://terrain/"+geysertype.to_lower()+"_"+color_select.get_item_text(index).to_lower()+".png")
	feature =  Feature[geysertype+"Geyser"+color_select.get_item_text(index)]

func add_terrain() -> void:
	if t_name.text != "":
		terrain.get_or_add(t_name.text, {"t": t, "biome": biome_select.text, feature_ore_ores(): get_feature()})
		list.add_item(t_name.text)
		t_name.text = ""
		type_select.select(0)
		set_edit_type(0)
		oreyield = []
	else:
		pass

func append_yield(pattern: Dictionary):
	oreyield.append({"weight": weight.value, "cube": pattern})
	if patternname.text != "":
		oreyieldlist.add_item(patternname.text)
	else:
		oreyieldlist.add_item("Unnamed Pattern")

func feature_ore_ores() -> String: #Jelau22
	if t == "ore":
		return "ores"
	else:
		return "feature"

func get_feature():
	if t == "ore":
		return oreyield
	else:
		return feature

func open_oreyield_menu() -> void:
	oreyieldmenu.show()
	image.hide()
	terrainsettings.hide()
	btns.hide()

func close_oreyield_menu() -> void:
	oreyieldmenu.hide()
	image.show()
	terrainsettings.show()
	btns.show()

func save_data() -> void:
	var terrain_json = FileAccess.open(main.filepath+"/terrain.json", FileAccess.WRITE)
	var terrain_save = FileAccess.open(main.filepath+"/terrain.bkp", FileAccess.WRITE)
	terrain_json.store_string(JSON.stringify(terrain))
	terrain_save.store_var(terrain)
