extends Control

onready var loading = preload("res://scenes/Interface/Loading.tscn")
onready var credits_scene = preload("res://scenes/Interface/Credits.tscn")
var selected = 0
var current_tab = 0

onready var selection = [
	$Main,
	$Options,
	$Credits
]

func _ready():
	select_index(0)

func _input(event):
	if event.is_action_pressed("ui_up"):
		unselect_index()
		selected -= 1
		if selected < 0:
			selected = selection[current_tab].get_child_count() - 1
		select_index(selected)
	elif event.is_action_pressed("ui_down"):
		unselect_index()
		selected += 1
		if selected == selection[current_tab].get_child_count():
			selected = 0
		select_index(selected)
	elif event.is_action_pressed("select"):
		unselect_index()
		if (current_tab == 0):
			handle_selection()
		elif (current_tab == 1):
			handle_option_selection()
		elif (current_tab == 2):
			$AnimationPlayer.play("credits-main")
			current_tab = 0
			selected = 0
			select_index(0)

func unselect_index():
	for select in selection[current_tab].get_children():
		select.get_node("Label").get_font("font").outline_size = 0

func select_index(index):
	selection[current_tab].get_child(index).get_node("Label").get_font("font").outline_size = 8

func handle_selection():
	if selected == 0:
		get_tree().change_scene_to(loading)
	elif selected == 1:
		$AnimationPlayer.play("main-options")
		current_tab = 1
		selected = 0
		select_index(0)
	elif selected == 2:
		$AnimationPlayer.play("main-credits")
		current_tab = 2
		selected = 0
		select_index(0)
	elif selected == 3:
		get_tree().quit()

func handle_option_selection():
	if selected == 0:
		pass
	elif selected == 1:
		pass
	elif selected == 2:
		pass
	elif selected == 3:
		$AnimationPlayer.play("options-main")
		current_tab = 0
		selected = 0
		select_index(0)


func _on_Lead_finished():
	$Sound/Lead.play()
	$Sound/Main.play()
