extends Node

var count_time : bool = false
var total_time = 0

var death_screen
var level = 0
var player_dead : bool = false

func _ready():
	death_screen = preload("res://src/DeathScreen/DeathScreen.tscn").instance()

func _process(delta):
	if player_dead && Input.is_action_just_pressed("restart"):
		restart_level()
		start_timer()
		remove_child(death_screen)
	if count_time:
		total_time += delta
		$CanvasLayer/Label.text = "Time: " +  str(stepify(total_time, 0.1))
	pass


func start_timer():
	$CanvasLayer/Label.show()	
	count_time = true

func stop_timer():
	$CanvasLayer/Label.hide()
	count_time = false

func reset_timer():
	total_time = 0


func next_level():
	level += 1
	get_tree().change_scene("res://src/Level/Level" + str(level) + ".tscn")
	pass


func restart_level():
	get_tree().change_scene("res://src/Level/Level" + str(level) + ".tscn")
	pass

func reset_game():
	level = 0

func player_died():
	add_child(death_screen)
	stop_timer()
	player_dead = true
	pass
