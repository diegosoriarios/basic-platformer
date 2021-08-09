extends Control

onready var selection = $Container
onready var loading = preload("res://scenes/Interface/Loading.tscn")
onready var settings_scene = preload("res://scenes/Interface/Options.tscn")
onready var credits_scene = preload("res://scenes/Interface/Credits.tscn")
var selected = 0

func _ready():
	select_index(0)

func _input(event):
	if event.is_action_pressed("ui_up"):
		unselect_index()
		selected -= 1
		if selected < 0:
			selected = selection.get_child_count() - 1
		select_index(selected)
	elif event.is_action_pressed("ui_down"):
		unselect_index()
		selected += 1
		if selected == selection.get_child_count():
			selected = 0
		select_index(selected)
	elif event.is_action_pressed("select"):
		handle_selection()

func unselect_index():
	for select in selection.get_children():
		select.get_font("font").outline_size = 0

func select_index(index):
	selection.get_child(index).get_font("font").outline_size = 8

func handle_selection():
	if selected == 0:
		get_tree().change_scene_to(loading)
	elif selected == 1:
		get_tree().change_scene_to(settings_scene)
	elif selected == 2:
		get_tree().change_scene_to(credits_scene)
	elif selected == 3:
		get_tree().quit()
