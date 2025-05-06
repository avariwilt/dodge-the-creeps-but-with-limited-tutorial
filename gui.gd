extends CanvasLayer

signal start_game
signal game_over_exit
signal restart
signal delete_highscore

@export var full_heart: Texture
@export var half_heart: Texture
@export var empty_heart: Texture

const max_health=300
var hearths
var highscores_contain 
var delete_highscores_contain

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_screen()
	hearths=$health.get_children()
	highscores_contain= $Highscore_Screen/PanelContainer/Panel/Highscores_container.get_children()
	delete_highscores_contain=$"Highscore_Screen/PanelContainer/Panel/delete buttons".get_children()
	$game_overScreen.hide()
	$Highscore_Screen.hide()
	
	for i in range(delete_highscores_contain.size()) :
		var button = delete_highscores_contain[i]
		button.set_meta("index",i)
		button.pressed.connect(_on_delete_highscore_btn_pressed.bind(button))
	pass # Replace with function body.

func update_score(score) ->void :
	$Score.text=str(score)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	start_game.emit()
	$MainMenu_Screen.hide()
	update_health(max_health)
	$health.show()
	$Score.show()
	pass # Replace with function body.

func update_health(health) -> void:
	for i in range(hearths.size()):
		if i*100>health-100 :
			hearths[i].texture=empty_heart
		else:
			hearths[i].texture=full_heart
	pass

func game_over(score)->void :
	$game_overScreen/final_score.text="Final Score : "+ str(score)
	$game_overScreen.show()
	$game_overScreen/AnimationPlayer.play("game over")
	##await $game_overScreen/AnimationPlayer.animation_finished
	pass


func _on_exit_pressed() -> void:
	$Highscore_Screen/AnimationPlayer.play("dissappear")
	await $Highscore_Screen/AnimationPlayer.animation_finished
	pass # Replace with function body.

func start_screen()-> void:
	$health.hide()
	$MainMenu_Screen.show()
	$Score.hide()
	pass


func _on_exit_game_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_highscore_pressed() -> void:
	$Highscore_Screen/AnimationPlayer.play("appear")
	$Highscore_Screen.show()
	pass # Replace with function body.


func _on_main_menu_button_pressed() -> void:
	$game_overScreen/AnimationPlayer.play("game over_escape")
	await $game_overScreen/AnimationPlayer.animation_finished
	$game_overScreen.hide()
	game_over_exit.emit()
	$health.hide()
	$Score.hide()
	$MainMenu_Screen.show()
	pass # Replace with function body.


func _on_restart_button_pressed() -> void:
	$game_overScreen/AnimationPlayer.play("game over_escape")
	await $game_overScreen/AnimationPlayer.animation_finished
	$game_overScreen.hide()
	restart.emit()
	pass # Replace with function body.
	
func update_highscores(highscores : Array) -> void:
	for i in highscores_contain.size():
		if i < highscores.size():
			highscores_contain[i].text = str(highscores[i])
		else:
			highscores_contain[i].text = "empty"

func _on_delete_highscore_btn_pressed(button)-> void :
	var index = button.get_meta("index")
	delete_highscore.emit(index)
	print("Deleting highscore at index:", index)
	
	pass
