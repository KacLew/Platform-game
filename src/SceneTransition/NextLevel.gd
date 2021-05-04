extends Area2D

onready var collision = $CollisionShape2D




func _on_Area2D_body_entered(body):
	if body.name == "Player":
		SceneTransition.next_level()
	pass # Replace with function body.
