extends Control



func _on_Level7_tree_entered():
	SceneTransition.stop_timer()
	$Label4.text = "Total time:" + str(stepify(SceneTransition.total_time, 0.1)) + " seconds"


func _on_Button_button_down():
	SceneTransition.reset_timer()
	SceneTransition.reset_game()
	get_tree().change_scene("res://src/StartingScreen/Platformer demo.tscn")


func _on_Button2_button_down():
	get_tree().quit()
