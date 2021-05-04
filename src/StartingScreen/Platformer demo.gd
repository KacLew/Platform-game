extends Control


func _on_StartGame_button_down():
	SceneTransition.next_level()
	SceneTransition.start_timer()


func _on_ExitGame_button_down():
	get_tree().quit()
	pass # Replace with function body.
