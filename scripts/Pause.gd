extends Control

onready var selection = $Selection
#onready var option_scene = preload("res://scenes/Interface/Options.tscn")
var selected = 0

func _ready():
	select_index(0)

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
	elif event.is_action_pressed("ui_up"):
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
		get_tree().paused = false
		visible = false
	elif selected == 1:
		pass
	else:
		handle_save()
		get_tree().quit()

func handle_save():
	pass
