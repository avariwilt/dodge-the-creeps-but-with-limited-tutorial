extends Node

@export var mob_scene : PackedScene

var scores_file
var path ="user://scores_file.save"
@export var highscore_table :Array

var portals
var size=1
var score=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists(path) :
		scores_file=FileAccess.open(path,FileAccess.READ)
		highscore_table = scores_file.get_var()
		scores_file.close()
		
	portals=$Portal.get_children()
	print("Portals:", portals)
	#start_game()
	$player.position=$Start_Position.position
	$gui.update_highscores(highscore_table)
	$gui.show()
	pass # Replace with function body.





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_player_hit(hit_power,enemy_position) -> void:
	$player.take_damage(hit_power,enemy_position)
	$gui.update_health($player.health)
	print($player.health)
	if ($player.health==0) :
		game_over()
		pass
	pass # Replace with function body.
	
func enemy_spawn()-> void:
	#print("mob spawn")
	var mob=mob_scene.instantiate()
	var portal = portals[randi()%portals.size()]
	var mob_spawn_location=portal.position
	
	mob.position=mob_spawn_location
	var scale =randi_range(1,size)
	var direction = randf_range(-PI,+PI)
	mob.get_node("AnimatedSprite2D").flip_h = (direction < -PI/2) or (direction > PI/2)
	#mob.direction= direction
	for child in mob.get_children() :
		child.scale*=scale
	
	var velocity = Vector2(randf_range(150.0,250.0),0.0)
	mob.linear_velocity=velocity.rotated(direction);
	mob.add_to_group("monster")
	
	add_child(mob)
	pass



func _on_start_timer_timeout() -> void:
	$MobSpawnTimer.start()
	$ScoreTimer.start()
	pass # Replace with function body.


func _on_mob_spawn_timer_timeout() -> void:
	enemy_spawn()
	pass # Replace with function body.


func _on_score_timer_timeout() -> void:
	score+=1
	$gui.update_score(score)
	if (score%20==0):
		if (size<7):
			size+=1
		$MobSpawnTimer.wait_time=1.0/(size*2.2)
		
	
	print("score = ",score)
	
	pass # Replace with function body.


func start_game() -> void:
	print("game start")
	$player.position=$Start_Position.position
	$player.can_move=true
	$gui.update_health($player.health)
	#$player._ready()
	#$player.show()
	score=0
	$gui.update_score(score)
	$StartTimer.start()
	pass # Replace with function body.
	
	
func game_over() -> void:
	$ScoreTimer.stop()
	$player.death();
	$gui.game_over(score)
	highscore_table.append(score)
	highscore_table.sort()
	highscore_table.reverse()
	$gui.update_highscores(highscore_table)
	save()
	pass


func _on_gui_game_over_exit() -> void:
	$MobSpawnTimer.stop()
	get_tree().call_group("monster", "queue_free")
	$player._ready()
	$player.position=$Start_Position.position
	pass # Replace with function body.

#I don't like how they are literally the same functions :'[

func _on_gui_restart() -> void:
	#$MobSpawnTimer.stop()
	#get_tree().call_group("monster", "queue_free")
	#$player._ready()
	#$player.position=$Start_Position.position
	_on_gui_game_over_exit()
	start_game()
	pass # Replace with function body.
	
	
func exit_and_save() ->void :
	scores_file=FileAccess.open(path,FileAccess.WRITE)
	if highscore_table.size() > 30:
		highscore_table.resize(30)
	scores_file.store_var(highscore_table)
	scores_file.close()
	get_tree().quit()
	pass
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		exit_and_save()

func save() -> void :
	scores_file=FileAccess.open(path,FileAccess.WRITE)
	if highscore_table.size() > 30:
		highscore_table.resize(30)
	scores_file.store_var(highscore_table)
	scores_file.close()


func _on_gui_delete_highscore(index) -> void:
	highscore_table.remove_at(index)
	highscore_table.sort()
	highscore_table.reverse()
	$gui.update_highscores(highscore_table)
	save()
	pass # Replace with function body.
