extends Control

@onready var settingspanel: Control = $GeneralSettings/FileEdit
const Metaedit = preload("uid://cc6kmvmodommy")
const Upgradeedit = preload("uid://cpbw0qijwc153")
const Fueledit = preload("uid://d48pqsbcmi2o")
const Pitedit = preload("uid://dxrynml83og74")
const Stampedit = preload("uid://dhxuloefcouil")
const Terrainedit = preload("uid://brcjfhaxke28f")
@onready var meta: Button = $GeneralSettings/ChooseFile/Meta
@onready var recipes_fuel: Button = $"GeneralSettings/ChooseFile/recipes-fuel"
@onready var recipes_pit: Button = $"GeneralSettings/ChooseFile/recipes-pit"
@onready var recipes_stamper: Button = $"GeneralSettings/ChooseFile/recipes-stamper"
@onready var terrain: Button = $GeneralSettings/ChooseFile/terrain
@onready var upgrades: Button = $GeneralSettings/ChooseFile/upgrades
@onready var open: Button = $GeneralSettings/FileSettings/open
@onready var file_dialog: FileDialog = $FileDialog
@onready var filepathobj: LineEdit = $GeneralSettings/FileSettings/LineEdit

var filepath: String = ""

func _ready():
	file_dialog.hide()
	meta.disabled = filepath == ""
	recipes_fuel.disabled = filepath == ""
	recipes_pit.disabled = filepath == ""
	recipes_stamper.disabled = filepath == ""
	terrain.disabled = filepath == ""
	upgrades.disabled = filepath == ""
	open.disabled = filepath == ""

func open_meta_settings() -> void:
	for i in settingspanel.get_children():
		i.save_data()
		i.queue_free()
	var metasettings = Metaedit.instantiate()
	settingspanel.add_child(metasettings)

func set_file_path(new_text: String) -> void:
	filepath = new_text
	_ready()

func open_upgrade_settings() -> void:
	for i in settingspanel.get_children():
		i.save_data()
		i.queue_free()
	var ug = Upgradeedit.instantiate()
	settingspanel.add_child(ug)

func open_fuel_settings() -> void:
	for i in settingspanel.get_children():
		i.save_data()
		i.queue_free()
	var fuel = Fueledit.instantiate()
	settingspanel.add_child(fuel)

func open_pit_settings() -> void:
	for i in settingspanel.get_children():
		i.save_data()
		i.queue_free()
	var pit = Pitedit.instantiate()
	settingspanel.add_child(pit)

func open_stamper_settings() -> void:
	for i in settingspanel.get_children():
		i.save_data()
		i.queue_free()
	var stamp = Stampedit.instantiate()
	settingspanel.add_child(stamp)

func open_dc() -> void:
	OS.shell_open("https://discord.gg/6BeNMzPMyY")

func open_file_location() -> void:
	if filepath != "takemetotheulliverse":
		OS.shell_open(filepath)
	else:
		OS.shell_open("https://discord.gg/aaNnUXsJ5M")

func open_terrain_settings() -> void:
	for i in settingspanel.get_children():
		i.save_data()
		i.queue_free()
	var terrainsettings = Terrainedit.instantiate()
	settingspanel.add_child(terrainsettings)

func open_doc() -> void:
	OS.shell_open(ProjectSettings.globalize_path("res://Cubetory Editor Documentation.pdf"))

func open_file_select() -> void:
	file_dialog.show()

func file_selected(path: String) -> void:
	filepathobj.text = path
	set_file_path(path)
