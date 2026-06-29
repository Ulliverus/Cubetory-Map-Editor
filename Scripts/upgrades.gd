extends Control

@onready var main: Control = $"/root/Control"
@onready var edit_col_cost: HBoxContainer = $upgradeedit/EditTierCost
@onready var add_tier: Button = $upgradeedit/BtnAddUpgrade
@onready var tiers: VBoxContainer = $upgradeedit/Tiers
@onready var add_col: Button = $upgradeedit/AddRow
@onready var upgrade_menu: HBoxContainer = $"UpgradeMenu"
@onready var cancel: Button = $"UpgradeMenu/Descriptions/Cancel"
@onready var save: Button = $"UpgradeMenu/Content/Save"
@onready var title: LineEdit = $"UpgradeMenu/Content/Title"
@onready var description: LineEdit = $"UpgradeMenu/Content/Description"
@onready var unlocks: TextEdit = $"UpgradeMenu/Content/Unlocks"
@onready var save_all: Button = $upgradeedit/Save
@onready var start_unlock: LineEdit = $upgradeedit/StartUnlock

const progression = ["nutrient", "hydration", "construction", "power", "music", "truck", "hammer", "timer", "computer", "spicy", "phone", "atomic"]

var values: Array
var value_active: Vector2i
var unlocked_from_start: Array

func _ready() -> void:
	add_tier.pressed.connect(add_upgrade_tier)
	add_col.pressed.connect(add_upgrade_col)
	cancel.pressed.connect(discard_config)
	save.pressed.connect(save_config)
	upgrade_menu.hide()
	save_all.pressed.connect(save_data)
	if FileAccess.file_exists(main.filepath+"/upgrades.json"):
		values = JSON.parse_string(FileAccess.open(main.filepath+"/upgrades.json", FileAccess.READ).get_as_text())["rows"]
		for i in values.size():
			add_upgrade_tier(true)
		if !values.is_empty():
			for i in values[0].size():
				add_upgrade_col(true)
		if edit_col_cost.get_child_count()-1==JSON.parse_string(FileAccess.open(main.filepath+"/upgrades.json", FileAccess.READ).get_as_text())["rates"].size():
			set_rates(JSON.parse_string(FileAccess.open(main.filepath+"/upgrades.json", FileAccess.READ).get_as_text())["rates"])
		start_unlock.text = arr_to_str(JSON.parse_string(FileAccess.open(main.filepath+"/upgrades.json", FileAccess.READ).get_as_text())["start_unlocked"])

func add_upgrade_tier(load_from_file: bool = false):
	if tiers.get_child_count() < 12:
		if !load_from_file:
			values.append([])
		tiers.add_child(HBoxContainer.new())
		tiers.get_child(-1).size_flags_vertical = 3 #sets container sizing to fill and expand
		var lbl = load("res://Scenes/ugrowname.tscn").instantiate()
		tiers.get_child(-1).add_child(lbl)
		tiers.get_child(-1).get_child(0).get_child(0).texture = load("res://all_icons/no_bg/"+progression[tiers.get_child_count()-1]+".png")
		tiers.get_child(-1).get_child(0).delete.connect(delete_tier.bind(tiers.get_child_count()-1))
		tiers.get_child(-1).get_child(0).move_down.connect(move_tier.bind(tiers.get_child_count()-1, tiers.get_child_count()))
		tiers.get_child(-1).get_child(0).move_up.connect(move_tier.bind(tiers.get_child_count()-1, tiers.get_child_count()-2))
		for i in edit_col_cost.get_child_count()-1:
			tiers.get_child(-1).add_child(UGEditBtn.new())
			tiers.get_child(-1).get_child(-1).init(Vector2i(tiers.get_child(-1).get_child_count()-2, tiers.get_child_count()-1))
			if !load_from_file:
				values[-1].append({"id": "empty"})
	else:
		add_tier.disabled = true
		add_tier.text = "Max tier count reached"

func add_upgrade_col(load_from_file: bool = false):
	if edit_col_cost.get_child_count() < 10:
		edit_col_cost.add_child(LineEdit.new())
		edit_col_cost.get_child(edit_col_cost.get_child_count()-1).size_flags_horizontal = 3
		for i in tiers.get_child_count():
			tiers.get_child(i).add_child(UGEditBtn.new())
			tiers.get_child(i).get_child(-1).init(Vector2i(tiers.get_child(i).get_child_count()-2, i))
			if !load_from_file:
				values[i].append({"id": "empty"})
	else:
		add_col.disabled = true
		add_col.text = "Max row count reached"

func open_ug_config(pos: Vector2i):
	upgrade_menu.show()
	value_active = pos
	if values[pos.y][pos.x]["id"] != "empty":
		title.text = values[pos.y][pos.x]["title"]
		description.text = values[pos.y][pos.x]["description"]
		unlocks.text = arr_to_str(values[pos.y][pos.x]["unlocks"])
	else:
		title.text = ""
		description.text = ""
		unlocks.text = ""
	start_unlock.editable = false
	add_col.disabled = true
	add_tier.disabled = true
	save_all.disabled = true

func save_config():
	values[value_active.y][value_active.x] = {"id": "u_"+str(value_active), "title": title.text, "description": description.text, "unlocks": str_to_arr(unlocks.text)}
	discard_config()
func discard_config():
	upgrade_menu.hide()
	value_active = Vector2i(-1,-1)
	title.text = ""
	description.text = ""
	unlocks.text = ""
	start_unlock.editable = true
	add_col.disabled = false
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
	if out.ends_with(", "):
		out = out.erase(out.length()-2, 2)
	return out

func get_rates()-> Array:
	var out = []
	for i in edit_col_cost.get_child_count()-1:
		out.append(edit_col_cost.get_child(i+1).text.to_int())
	return out
func set_rates(rates: Array):
	for i in rates.size():
		edit_col_cost.get_child(i+1).text = str(rates[i])

func save_data():
	var upgrades_json = FileAccess.open(main.filepath+"/upgrades.json", FileAccess.WRITE)
	upgrades_json.store_string(JSON.stringify({"rates": get_rates(),"start_unlocked": str_to_arr(start_unlock.text),"rows": values}))

func delete_tier(idx: int):
	values.remove_at(idx)
	var count: int = idx
	while count < values.size():
		for ug in values[count]:
			if ug["id"] != "empty":
				ug["id"] = "u_("+str(ug["id"].get_slice(",", 0).to_int())+", "+str(ug["id"].get_slice(",", 1).to_int()-1)+")"
		count+=1
	save_data()
	main.open_upgrade_settings()

func move_tier(idx: int, target: int):
	var move = values.pop_at(idx-1)
	values.insert(target+1, move)
	for ug in values[idx]:
		if ug["id"] != "empty":
			ug["id"] = "u_("+str(ug["id"].get_slice(",", 0).to_int())+", "+str(idx)+")"
	for ug in values[target]:
		if ug["id"] != "empty":
			ug["id"] = "u_("+str(ug["id"].get_slice(",", 0).to_int())+", "+str(target)+")"
	main.open_upgrade_settings()
