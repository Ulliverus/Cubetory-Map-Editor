extends VBoxContainer

@onready var main: Control = $"/root/Control"
@onready var edit_tier_cost: HBoxContainer = $EditTierCost
@onready var add_tier: Button = $BtnAddUpgrade
@onready var tiers: VBoxContainer = $Tiers
@onready var add_row: Button = $AddRow
@onready var upgrade_menu: HBoxContainer = $"../UpgradeMenu"
@onready var cancel: Button = $"../UpgradeMenu/Descriptions/Cancel"
@onready var save: Button = $"../UpgradeMenu/Content/Save"
@onready var title: LineEdit = $"../UpgradeMenu/Content/Title"
@onready var description: LineEdit = $"../UpgradeMenu/Content/Description"
@onready var unlocks: TextEdit = $"../UpgradeMenu/Content/Unlocks"
@onready var save_all: Button = $Save
@onready var start_unlock: LineEdit = $StartUnlock

var values: Dictionary
var value_active: Vector2i
var unlocked_from_start: Array

func _ready() -> void:
	add_tier.pressed.connect(add_upgrade_tier)
	add_row.pressed.connect(add_upgrade_row)
	cancel.pressed.connect(discard_config)
	save.pressed.connect(save_config)
	upgrade_menu.hide()
	save_all.pressed.connect(save_data)
	if FileAccess.file_exists(main.filepath+"/upgrades.json"):
		values = organize_reveng(JSON.parse_string(FileAccess.open(main.filepath+"/upgrades.json", FileAccess.READ).get_as_text())["rows"])
		if values != {}:
			for i in values.keys()[values.size()-1].x+1:
				add_upgrade_tier()
			for i in values.keys()[values.size()-1].y+1:
				add_upgrade_row()
		set_rates(JSON.parse_string(FileAccess.open(main.filepath+"/upgrades.json", FileAccess.READ).get_as_text())["rates"])
		start_unlock.text = arr_to_str(JSON.parse_string(FileAccess.open(main.filepath+"/upgrades.json", FileAccess.READ).get_as_text())["start_unlocked"])

func add_upgrade_tier():
	if tiers.get_child_count() < 12:
		tiers.add_child(HBoxContainer.new())
		tiers.get_child(tiers.get_child_count()-1).size_flags_vertical = 3 #sets container sizing to fill and expand
		for i in edit_tier_cost.get_child_count():
			tiers.get_child(-1).add_child(UGEditBtn.new())
			tiers.get_child(-1).get_child(-1).init(Vector2i(tiers.get_child(-1).get_child_count()-1, tiers.get_child_count()-1))
	else:
		add_tier.disabled = true
		add_tier.text = "Max tier count reached"

func add_upgrade_row():
	if edit_tier_cost.get_child_count() < 10:
		edit_tier_cost.add_child(LineEdit.new())
		edit_tier_cost.get_child(edit_tier_cost.get_child_count()-1).size_flags_horizontal = 3
		for i in tiers.get_child_count():
			tiers.get_child(i).add_child(UGEditBtn.new())
			tiers.get_child(i).get_child(-1).init(Vector2i(tiers.get_child(i).get_child_count()-1, i))
	else:
		add_row.disabled = true
		add_row.text = "Max row count reached"

func open_ug_config(pos: Vector2i):
	upgrade_menu.show()
	value_active = pos
	title.text = values[pos]["title"]
	description.text = values[pos]["description"]
	unlocks.text = arr_to_str(values[pos]["unlocks"])
	start_unlock.editable = false
	add_row.disabled = true
	add_tier.disabled = true
	save_all.disabled = true

func save_config():
	values[value_active] = {"id": "u_"+str(value_active), "title": title.text, "description": description.text, "unlocks": str_to_arr(unlocks.text)}
	discard_config()
func discard_config():
	upgrade_menu.hide()
	value_active = Vector2i(-1,-1)
	title.text = ""
	description.text = ""
	unlocks.text = ""
	start_unlock.editable = true
	add_row.disabled = false
	add_tier.disabled = false
	save_all.disabled = false

func str_to_arr(str_in: String) -> Array:
	var out = []
	for i in str_in.count(", ")+1:
		out.append(str_in.get_slice(", ", i))
	return out
func arr_to_str(arr_in: Array)->String:
	var out: String = ""
	for i in arr_in:
		out += str(i)+", "
	return out

func get_rates()-> Array:
	var out = []
	for i in edit_tier_cost.get_child_count():
		out.append(edit_tier_cost.get_child(i).text.to_int())
	return out
func set_rates(rates: Array):
	for i in rates.size():
		edit_tier_cost.get_child(i).text = str(rates[i])

func save_data():
	var upgrades_json = FileAccess.open(main.filepath+"/upgrades.json", FileAccess.WRITE)
	upgrades_json.store_string(JSON.stringify({"rates": get_rates(),"start_unlocked": str_to_arr(start_unlock.text),"rows": organise(values.values())}))

func organise(dict: Array) -> Array:
	var out: Array = []
	for i in edit_tier_cost.get_child_count():
		out.append([])
	for i in dict.size():
		out[i%edit_tier_cost.get_child_count()].append(dict[i])
	return out

func organize_reveng(arr: Array) -> Dictionary:
	var out: Dictionary = {}
	var x:=0
	var y:=0
	if arr == []:
		return {}
	for row in arr:
		for ug in row:
			out.get_or_add(Vector2i(x,y), ug)
			x+=1
		y+=1
	return out
