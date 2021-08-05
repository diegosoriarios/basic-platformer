extends Control

onready var selection = $Selection
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
	elif event.is_action_pressed("ui_left"):
		handle_sub_slider()
	elif event.is_action_pressed("ui_right"):
		handle_add_slider()

func unselect_index():
	for select in selection.get_children():
		select.get_node("Label").get_font("font").outline_size = 0

func select_index(index):
	selection.get_child(index).get_node("Label").get_font("font").outline_size = 8

func handle_selection():
	if selected == 0:
		handle_toggle()
	elif selected == 1 or selected == 2:
		pass

func handle_add_slider():
	if selected == 0:
		handle_toggle()
	elif selected == 2:
		$Selection/MusicVolume/MusicVolumeSlider.value += 1
	elif selected == 3:
		$Selection/FXVolume/FXSlider.value += 1

func handle_sub_slider():
	if selected == 0:
		handle_toggle()
	elif selected == 2:
		$Selection/MusicVolume/MusicVolumeSlider.value -= 1
	elif selected == 3:
		$Selection/FXVolume/FXSlider.value -= 1

func handle_save():
	pass

func handle_toggle():
	settings.fullscreen = !settings.fullscreen
	$Selection/Fullscreen/Label.toggle_mode = settings.fullscreen
	OS.window_fullscreen = settings.fullscreen

func _on_Fullscreen_toggled(button_pressed):
	handle_toggle()
