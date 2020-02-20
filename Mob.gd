extends RigidBody2D

export var min_speed = 150 #minimum speed range
export var max_speed = 250 #maximum speed range
var mob_types = ["walk", "swim", "fly"]

#randomly choose one of the three animation types from the mob_types list
func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()] #randi() % n is the standard way to get a random integer between 0 and n-1.

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#queue_free() will delete the current node at the end of the current frame
func _on_start_game():
	queue_free()
