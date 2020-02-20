extends Node

export (PackedScene) var Mob #export (PackedScene) allows us to choose the Mob scene we want to instance.
var score

func _ready():
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	#call the corresponding HUD function
	$HUD.show_game_over()
	#stop Music node
	$Music.stop()
	#Play DeathSound Node
	$DeathSound.play()
	
#start_game() signal emitted from HUD
func _on_HUD_start_game():
	new_game()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	#update the score display and show the “Get Ready” message
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	#play Music node
	$Music.play()
	

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_ScoreTimer_timeout():
	score += 1
	#keep the display in sync with the changing score
	$HUD.update_score(score)
	
func _on_MobTimer_timeout():
	#Choose random location on Path2D
	$MobPath/MobSpawnLocation.set_offset(randi())
	#Create Mob instance and add it to the scene
	var mob = Mob.instance()
	add_child(mob)
	#Set the Mob's direction perpindicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location
	mob.position = $MobPath/MobSpawnLocation.position
	#Add some randomness to the direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	#Set the velocity (speed & direction)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	#This line tells the new Mob node (referenced by the mob variable) 
	#to respond to any start_game signal emitted by the HUD node by running its _on_start_game() function.
	$HUD.connect("start_game", mob, "_on_start_game")
	

