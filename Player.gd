extends Area2D

signal hit
export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size #size of the game window

func _ready():
	screen_size = get_viewport_rect().size #find the size of the game window
	hide() #player will be hidden when the game starts

#movement of sprite
func _process(delta): #_process() is called every frame, delta helps timing remain consistent despite changes in frame rate
	var velocity = Vector2() # The player's movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play() #same as get_node("AnimatedSprite").play(). $ is shorthand for get_node(). 
	else:
		$AnimatedSprite.stop()
	
	#Prevent player from leaving the screen
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x) #clamp() to prevent player leaving the screen. Clamping a value means restricting it to a given range.
	position.y = clamp(position.y, 0, screen_size.y)
		
	#change direction of sprite is facing based on the direction of movement.
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false  #flip_v & flip_h is builtin property 
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y !=0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		
	

# warning-ignore:unused_argument
func _on_Player_body_entered(body):
	hide() #hides the player 
	emit_signal("hit") #signal emitted each time player gets hit
	$CollisionShape2D.set_deferred("disabled", true) # disable player's collision so hit signal not triggered more than once
	#Disabling the area’s collision shape can cause an error if it happens in the middle of the engine’s collision processing. 
	#Using set_deferred() allows us to have Godot wait to disable the shape until it’s safe to do so. 

#reset player when starting new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

