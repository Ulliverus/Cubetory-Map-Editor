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
@onready var recent_files: PopupMenu = $RecentFiles
@onready var load_recent: Button = $GeneralSettings/FileSettings/LineEdit/LoadRecent

var recent_paths: Array = []
var filepath: String = ""

func _ready():
	file_dialog.hide()
	close_recent()
	btntogglehaetschibaetschi()
	if FileAccess.file_exists("user://.recentpaths.txt"):
		recent_paths = FileAccess.open("user://.recentpaths.txt", FileAccess.READ).get_var()
		for pth in recent_paths:
			recent_files.add_item(pth)

func open_meta_settings() -> void:
	for i in settingspanel.get_children():
		i.save_data()
		i.queue_free()
	var metasettings = Metaedit.instantiate()
	settingspanel.add_child(metasettings)

func set_file_path(new_text: String) -> void:
	filepath = new_text
	btntogglehaetschibaetschi()

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

func open_bug_report() -> void:
	OS.shell_open("https://github.com/Ulliverus/Cubetory-Map-Editor/issues")

func close_recent() -> void:
	recent_files.hide()

func select_recent_path(idx: int) -> void:
	filepath = recent_files.get_item_text(idx)
	filepathobj.text = filepath
	file_selected(filepath)

func save_path_to_recent() -> void:
	recent_paths.append(filepath)
	recent_files.add_item(filepath)
	FileAccess.open("user://.recentpaths.txt", FileAccess.WRITE).store_var(recent_paths)

func open_history() -> void:
	recent_files.show()

func btntogglehaetschibaetschi():
	meta.disabled = filepath == ""
	recipes_fuel.disabled = filepath == ""
	recipes_pit.disabled = filepath == ""
	recipes_stamper.disabled = filepath == ""
	terrain.disabled = filepath == ""
	upgrades.disabled = filepath == ""
	open.disabled = filepath == ""
	load_recent.visible = filepath == ""
