extends HBoxContainer

@onready var u1: Button = $layout/upper1/t1
@onready var u2: Button = $layout/upper1/t2
@onready var u3: Button = $layout/upper2/ul
@onready var u4: Button = $layout/upper2/ur
@onready var l1: Button = $layout/middle1/l1
@onready var l2: Button = $layout/middle1/l2
@onready var f1: Button = $layout/middle1/f1
@onready var f2: Button = $layout/middle1/f2
@onready var r1: Button = $layout/middle1/r1
@onready var r2: Button = $layout/middle1/r2
@onready var b1: Button = $layout/middle1/b1
@onready var b2: Button = $layout/middle1/b2
@onready var l3: Button = $layout/middle2/l1
@onready var l4: Button = $layout/middle2/l2
@onready var f3: Button = $layout/middle2/f1
@onready var f4: Button = $layout/middle2/f2
@onready var r3: Button = $layout/middle2/r1
@onready var r4: Button = $layout/middle2/r2
@onready var b3: Button = $layout/middle2/b1
@onready var b4: Button = $layout/middle2/b2
@onready var d1: Button = $layout/lower1/t1
@onready var d2: Button = $layout/lower1/t2
@onready var d3: Button = $layout/lower2/ul
@onready var d4: Button = $layout/lower2/ur
@onready var stamp1: OptionButton = $Settings/setstamp
@onready var stamp2: OptionButton = $Settings/setstamp2
@onready var stamp3: OptionButton = $Settings/setstamp3
@onready var stamp4: OptionButton = $Settings/setstamp4
@onready var stamp5: OptionButton = $Settings/setstamp5
@onready var stamp6: OptionButton = $Settings/setstamp6
@onready var stamp7: OptionButton = $Settings/setstamp7
@onready var stamp8: OptionButton = $Settings/setstamp8

signal save_cube

@export var pit_cubes: bool = false
const colors = [Color.WHITE, Color.RED, Color.YELLOW, Color.BLUE, Color.WEB_GREEN, Color.PURPLE, Color.ORANGE, Color.SADDLE_BROWN]
const colstr = ["WHITE", "RED", "YELLOW", "BLUE", "GREEN", "PURPLE", "ORANGE", "BROWN"]
var btns := []
var pack: Dictionary = {"children": [{"pattern": ["WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE"], "stamp": ""}, {"pattern": ["WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE"], "stamp": ""}, {"pattern": ["WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE"], "stamp": ""}, {"pattern": ["WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE"], "stamp": ""}, {"pattern": ["WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE"], "stamp": ""}, {"pattern": ["WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE"], "stamp": ""}, {"pattern": ["WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE"], "stamp": ""}, {"pattern": ["WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE", "WHITE"], "stamp": ""}]}

func _ready() -> void:
	u1.pressed.connect(shift_color.bind(u1))
	u2.pressed.connect(shift_color.bind(u2))
	u3.pressed.connect(shift_color.bind(u3))
	u4.pressed.connect(shift_color.bind(u4))
	d1.pressed.connect(shift_color.bind(d1))
	d2.pressed.connect(shift_color.bind(d2))
	d3.pressed.connect(shift_color.bind(d3))
	d4.pressed.connect(shift_color.bind(d4))
	f1.pressed.connect(shift_color.bind(f1))
	f2.pressed.connect(shift_color.bind(f2))
	f3.pressed.connect(shift_color.bind(f3))
	f4.pressed.connect(shift_color.bind(f4))
	b1.pressed.connect(shift_color.bind(b1))
	b2.pressed.connect(shift_color.bind(b2))
	b3.pressed.connect(shift_color.bind(b3))
	b4.pressed.connect(shift_color.bind(b4))
	r1.pressed.connect(shift_color.bind(r1))
	r2.pressed.connect(shift_color.bind(r2))
	r3.pressed.connect(shift_color.bind(r3))
	r4.pressed.connect(shift_color.bind(r4))
	l1.pressed.connect(shift_color.bind(l1))
	l2.pressed.connect(shift_color.bind(l2))
	l3.pressed.connect(shift_color.bind(l3))
	l4.pressed.connect(shift_color.bind(l4))
	stamp1.item_selected.connect(set_stamp.bind(0))
	stamp2.item_selected.connect(set_stamp.bind(1))
	stamp3.item_selected.connect(set_stamp.bind(2))
	stamp4.item_selected.connect(set_stamp.bind(3))
	stamp5.item_selected.connect(set_stamp.bind(4))
	stamp6.item_selected.connect(set_stamp.bind(5))
	stamp7.item_selected.connect(set_stamp.bind(6))
	stamp8.item_selected.connect(set_stamp.bind(7))
	btns = [u1, u2, u3, u4, d1, d2, d3, d4, f1, f2, f3, f4, b1, b2, b3, b4, r1, r2, r3, r4, l1, l2, l3, l4]
	if pit_cubes:
		stamp1.add_icon_item(load("res://all_icons/no_bg/nutrient.png"), "Nutrient")
		stamp1.add_icon_item(load("res://all_icons/no_bg/hydration.png"), "Hydration")
		stamp1.add_icon_item(load("res://all_icons/no_bg/construction.png"), "Construction")
		stamp1.add_icon_item(load("res://all_icons/no_bg/power.png"), "Thunder")
		stamp1.add_icon_item(load("res://all_icons/no_bg/music.png"), "Music")
		stamp1.add_icon_item(load("res://all_icons/no_bg/truck.png"), "Truck")
		stamp1.add_icon_item(load("res://all_icons/no_bg/hammer.png"), "Hammer")
		stamp1.add_icon_item(load("res://all_icons/no_bg/timer.png"), "Watch")
		stamp1.add_icon_item(load("res://all_icons/no_bg/computer.png"), "Computer")
		stamp1.add_icon_item(load("res://all_icons/no_bg/spicy.png"), "Spicy")
		stamp1.add_icon_item(load("res://all_icons/no_bg/phone.png"), "Phone")
		stamp1.add_icon_item(load("res://all_icons/no_bg/atomic.png"), "Atomic")
		stamp2.add_icon_item(load("res://all_icons/no_bg/nutrient.png"), "Nutrient")
		stamp2.add_icon_item(load("res://all_icons/no_bg/hydration.png"), "Hydration")
		stamp2.add_icon_item(load("res://all_icons/no_bg/construction.png"), "Construction")
		stamp2.add_icon_item(load("res://all_icons/no_bg/power.png"), "Thunder")
		stamp2.add_icon_item(load("res://all_icons/no_bg/music.png"), "Music")
		stamp2.add_icon_item(load("res://all_icons/no_bg/truck.png"), "Truck")
		stamp2.add_icon_item(load("res://all_icons/no_bg/hammer.png"), "Hammer")
		stamp2.add_icon_item(load("res://all_icons/no_bg/timer.png"), "Watch")
		stamp2.add_icon_item(load("res://all_icons/no_bg/computer.png"), "Computer")
		stamp2.add_icon_item(load("res://all_icons/no_bg/spicy.png"), "Spicy")
		stamp2.add_icon_item(load("res://all_icons/no_bg/phone.png"), "Phone")
		stamp2.add_icon_item(load("res://all_icons/no_bg/atomic.png"), "Atomic")
		stamp3.add_icon_item(load("res://all_icons/no_bg/nutrient.png"), "Nutrient")
		stamp3.add_icon_item(load("res://all_icons/no_bg/hydration.png"), "Hydration")
		stamp3.add_icon_item(load("res://all_icons/no_bg/construction.png"), "Construction")
		stamp3.add_icon_item(load("res://all_icons/no_bg/power.png"), "Thunder")
		stamp3.add_icon_item(load("res://all_icons/no_bg/music.png"), "Music")
		stamp3.add_icon_item(load("res://all_icons/no_bg/truck.png"), "Truck")
		stamp3.add_icon_item(load("res://all_icons/no_bg/hammer.png"), "Hammer")
		stamp3.add_icon_item(load("res://all_icons/no_bg/timer.png"), "Watch")
		stamp3.add_icon_item(load("res://all_icons/no_bg/computer.png"), "Computer")
		stamp3.add_icon_item(load("res://all_icons/no_bg/spicy.png"), "Spicy")
		stamp3.add_icon_item(load("res://all_icons/no_bg/phone.png"), "Phone")
		stamp3.add_icon_item(load("res://all_icons/no_bg/atomic.png"), "Atomic")
		stamp4.add_icon_item(load("res://all_icons/no_bg/nutrient.png"), "Nutrient")
		stamp4.add_icon_item(load("res://all_icons/no_bg/hydration.png"), "Hydration")
		stamp4.add_icon_item(load("res://all_icons/no_bg/construction.png"), "Construction")
		stamp4.add_icon_item(load("res://all_icons/no_bg/power.png"), "Thunder")
		stamp4.add_icon_item(load("res://all_icons/no_bg/music.png"), "Music")
		stamp4.add_icon_item(load("res://all_icons/no_bg/truck.png"), "Truck")
		stamp4.add_icon_item(load("res://all_icons/no_bg/hammer.png"), "Hammer")
		stamp4.add_icon_item(load("res://all_icons/no_bg/timer.png"), "Watch")
		stamp4.add_icon_item(load("res://all_icons/no_bg/computer.png"), "Computer")
		stamp4.add_icon_item(load("res://all_icons/no_bg/spicy.png"), "Spicy")
		stamp4.add_icon_item(load("res://all_icons/no_bg/phone.png"), "Phone")
		stamp4.add_icon_item(load("res://all_icons/no_bg/atomic.png"), "Atomic")
		stamp5.add_icon_item(load("res://all_icons/no_bg/nutrient.png"), "Nutrient")
		stamp5.add_icon_item(load("res://all_icons/no_bg/hydration.png"), "Hydration")
		stamp5.add_icon_item(load("res://all_icons/no_bg/construction.png"), "Construction")
		stamp5.add_icon_item(load("res://all_icons/no_bg/power.png"), "Thunder")
		stamp5.add_icon_item(load("res://all_icons/no_bg/music.png"), "Music")
		stamp5.add_icon_item(load("res://all_icons/no_bg/truck.png"), "Truck")
		stamp5.add_icon_item(load("res://all_icons/no_bg/hammer.png"), "Hammer")
		stamp5.add_icon_item(load("res://all_icons/no_bg/timer.png"), "Watch")
		stamp5.add_icon_item(load("res://all_icons/no_bg/computer.png"), "Computer")
		stamp5.add_icon_item(load("res://all_icons/no_bg/spicy.png"), "Spicy")
		stamp5.add_icon_item(load("res://all_icons/no_bg/phone.png"), "Phone")
		stamp5.add_icon_item(load("res://all_icons/no_bg/atomic.png"), "Atomic")
		stamp6.add_icon_item(load("res://all_icons/no_bg/nutrient.png"), "Nutrient")
		stamp6.add_icon_item(load("res://all_icons/no_bg/hydration.png"), "Hydration")
		stamp6.add_icon_item(load("res://all_icons/no_bg/construction.png"), "Construction")
		stamp6.add_icon_item(load("res://all_icons/no_bg/power.png"), "Thunder")
		stamp6.add_icon_item(load("res://all_icons/no_bg/music.png"), "Music")
		stamp6.add_icon_item(load("res://all_icons/no_bg/truck.png"), "Truck")
		stamp6.add_icon_item(load("res://all_icons/no_bg/hammer.png"), "Hammer")
		stamp6.add_icon_item(load("res://all_icons/no_bg/timer.png"), "Watch")
		stamp6.add_icon_item(load("res://all_icons/no_bg/computer.png"), "Computer")
		stamp6.add_icon_item(load("res://all_icons/no_bg/spicy.png"), "Spicy")
		stamp6.add_icon_item(load("res://all_icons/no_bg/phone.png"), "Phone")
		stamp6.add_icon_item(load("res://all_icons/no_bg/atomic.png"), "Atomic")
		stamp7.add_icon_item(load("res://all_icons/no_bg/nutrient.png"), "Nutrient")
		stamp7.add_icon_item(load("res://all_icons/no_bg/hydration.png"), "Hydration")
		stamp7.add_icon_item(load("res://all_icons/no_bg/construction.png"), "Construction")
		stamp7.add_icon_item(load("res://all_icons/no_bg/power.png"), "Thunder")
		stamp7.add_icon_item(load("res://all_icons/no_bg/music.png"), "Music")
		stamp7.add_icon_item(load("res://all_icons/no_bg/truck.png"), "Truck")
		stamp7.add_icon_item(load("res://all_icons/no_bg/hammer.png"), "Hammer")
		stamp7.add_icon_item(load("res://all_icons/no_bg/timer.png"), "Watch")
		stamp7.add_icon_item(load("res://all_icons/no_bg/computer.png"), "Computer")
		stamp7.add_icon_item(load("res://all_icons/no_bg/spicy.png"), "Spicy")
		stamp7.add_icon_item(load("res://all_icons/no_bg/phone.png"), "Phone")
		stamp7.add_icon_item(load("res://all_icons/no_bg/atomic.png"), "Atomic")
		stamp8.add_icon_item(load("res://all_icons/no_bg/nutrient.png"), "Nutrient")
		stamp8.add_icon_item(load("res://all_icons/no_bg/hydration.png"), "Hydration")
		stamp8.add_icon_item(load("res://all_icons/no_bg/construction.png"), "Construction")
		stamp8.add_icon_item(load("res://all_icons/no_bg/power.png"), "Thunder")
		stamp8.add_icon_item(load("res://all_icons/no_bg/music.png"), "Music")
		stamp8.add_icon_item(load("res://all_icons/no_bg/truck.png"), "Truck")
		stamp8.add_icon_item(load("res://all_icons/no_bg/hammer.png"), "Hammer")
		stamp8.add_icon_item(load("res://all_icons/no_bg/timer.png"), "Watch")
		stamp8.add_icon_item(load("res://all_icons/no_bg/computer.png"), "Computer")
		stamp8.add_icon_item(load("res://all_icons/no_bg/spicy.png"), "Spicy")
		stamp8.add_icon_item(load("res://all_icons/no_bg/phone.png"), "Phone")
		stamp8.add_icon_item(load("res://all_icons/no_bg/atomic.png"), "Atomic")

func shift_color(btn: Button):
	if btn.get_child(0).get_meta("color") != 7:
		btn.get_child(0).set_meta("color", btn.get_child(0).get_meta("color")+1)
	else:
		btn.get_child(0).set_meta("color", 0)
	btn.get_child(0).self_modulate = colors[btn.get_child(0).get_meta("color")]
	pack["children"][btn.get_tooltip().to_int()-1]["pattern"][btn.get_meta("side")] = colstr[btn.get_child(0).get_meta("color")]

func set_stamp(icon: int, pos: int):
	pack["children"][pos]["stamp"] = stamp1.get_item_text(icon)
	for btn in btns:
		if btn.get_tooltip() == str(pos+1):
			btn.icon = stamp1.get_item_icon(icon)

func save() -> void:
	save_cube.emit(pack)
