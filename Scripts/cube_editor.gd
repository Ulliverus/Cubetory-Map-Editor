extends VBoxContainer

@onready var cube_editor: VBoxContainer = $"."
@onready var up: HBoxContainer = $up
@onready var upper: Button = $up/upper
@onready var mid: HBoxContainer = $mid
@onready var left: Button = $mid/left
@onready var front: Button = $mid/front
@onready var right: Button = $mid/right
@onready var back: Button = $mid/back
@onready var low: HBoxContainer = $low
@onready var bottom: Button = $low/bottom
@onready var set_stamp: OptionButton = $low/setstamp
@onready var save_btn: Button = $Save
@onready var random_color: CheckButton = $low/rand
@onready var instructions: Label = $up/instructions

const BLANK = preload("uid://0usj84e4dg5t")
const RAND_1 = preload("uid://d310vy07p5ln8")
const RAND_2 = preload("uid://d2b6nmq4cd5x4")

@export var can_random: bool = true
signal save_cube
var pattern: Dictionary = {"pattern": ["WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE"], "stamp": ""}
const colstr = ["WHITE", "RED", "YELLOW", "BLUE", "GREEN", "PURPLE", "ORANGE", "BROWN"]
const colors = [Color.WHITE, Color.RED, Color.YELLOW, Color.BLUE, Color.WEB_GREEN, Color.PURPLE, Color.ORANGE, Color.SADDLE_BROWN]
const stamps = {"No Stamp": "", "Bolt": "boltcomponent", "Circuit": "circuitcomponent", "Fuel": "fuel1", "Wire": "wirecomponent", "Mechanism": "mechanismcomponent", "Engine": "enginecomponent", "Dense Fuel": "fuel2", "Unstable Fuel": "fuel3"}
const rand = [BLANK, RAND_1, RAND_2]
const randstr = {BLANK: "WHITE", RAND_1: "*_1", RAND_2: "*_2"}
const strtostamp = {"": null, "boltcomponent": preload("uid://dlyyoks4ptwer"), "circuitcomponent": preload("uid://bg5l3kap2x3bm"), "fuel1": preload("uid://b5f07kxh47mpm"), "wirecomponent": preload("uid://op4uw7t4q8po"), "mechanismcomponent": preload("uid://cbph8n17mfnne"), "enginecomponent": preload("uid://uw744l5e5i8v"), "fuel2": preload("uid://lrt36go1qbvw"), "fuel3": preload("uid://chsmdu8ccm3ii")}

func _ready() -> void:
	upper.pressed.connect(shift_color.bind(upper))
	bottom.pressed.connect(shift_color.bind(bottom))
	front.pressed.connect(shift_color.bind(front))
	back.pressed.connect(shift_color.bind(back))
	left.pressed.connect(shift_color.bind(left))
	right.pressed.connect(shift_color.bind(right))
	set_stamp.item_selected.connect(change_stamp)
	save_btn.pressed.connect(save)
	random_color.disabled = !can_random
	if !can_random:
		instructions.text = "This cube pattern\ncannot be randomized."

func shift_color(btn: Button):
	if random_color.button_pressed:
		btn.get_child(0).self_modulate = Color.WHITE
		if btn.get_child(0).texture == RAND_2:
			btn.get_child(0).texture = BLANK
		else:
			btn.get_child(0).texture = rand[rand.find(btn.get_child(0).texture)+1]
		pattern["pattern"][btn.get_meta("order")] = randstr[btn.get_child(0).texture]
	elif btn.get_child(0).texture == BLANK:
		if btn.get_child(0).get_meta("color") != 7:
			btn.get_child(0).set_meta("color", btn.get_child(0).get_meta("color")+1)
		else:
			btn.get_child(0).set_meta("color", 0)
		btn.get_child(0).self_modulate = colors[btn.get_child(0).get_meta("color")]
		pattern["pattern"][btn.get_meta("order")] = colstr[btn.get_child(0).get_meta("color")]

func change_stamp(idx: int):
	upper.icon = set_stamp.get_item_icon(idx)
	bottom.icon = set_stamp.get_item_icon(idx)
	front.icon = set_stamp.get_item_icon(idx)
	back.icon = set_stamp.get_item_icon(idx)
	left.icon = set_stamp.get_item_icon(idx)
	right.icon = set_stamp.get_item_icon(idx)
	pattern["stamp"] = stamps[set_stamp.get_item_text(idx)]

func save() -> void:
	save_cube.emit(pattern)

func set_pattern(p):
	upper.get_child(0).self_modulate = colors[colstr.find(p["pattern"][0])]
	bottom.get_child(0).self_modulate = colors[colstr.find(p["pattern"][1])]
	left.get_child(0).self_modulate = colors[colstr.find(p["pattern"][2])]
	right.get_child(0).self_modulate = colors[colstr.find(p["pattern"][3])]
	front.get_child(0).self_modulate = colors[colstr.find(p["pattern"][4])]
	back.get_child(0).self_modulate = colors[colstr.find(p["pattern"][5])]
	upper.icon = strtostamp[p["stamp"]]
	bottom.icon = strtostamp[p["stamp"]]
	left.icon = strtostamp[p["stamp"]]
	right.icon = strtostamp[p["stamp"]]
	front.icon = strtostamp[p["stamp"]]
	back.icon = strtostamp[p["stamp"]]
