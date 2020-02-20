extends CanvasLayer

signal start_game #tells the Main node that the button has been pressed

#This function is called when we want to display a message temporarily, 
#such as “Get Ready”. On the MessageTimer, set the Wait Time to 2 and set the One Shot property to “On”.
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
#This function is called when the player loses. It will show “Game Over” for 2 seconds, 
#then return to the title screen and, after a brief pause, show the “Start” button.
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Dodge the\nCreeps!"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), 'timeout') # SceneTree’s create_timer() is alterative to using using a Timer node. Used to create a delay
	$StartButton.show()
	
#This function is called by Main whenever the score changes.
func update_score(score):
	$ScoreLabel.text = str(score)

#connect the pressed() signal of StartButton
func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

#Connect the timeout() signal of MessageTimer	
func _on_MessageTimer_timeout():
	$MessageLabel.hide()
