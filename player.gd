extends CharacterBody2D


@export var speed = 400
@export var health = 300
@export var knockback_duration = 0.2
const max_health=300

signal hit
#var kickback=false
var knockback_vector=Vector2.ZERO
var knockback_timer=0.0

@export var can_move=true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health=max_health
	$CollisionShape2D.set_deferred("disabled",false)
	$AnimatedSprite2D.animation="walk1"
	$AnimatedSprite2D.speed_scale=1
	$AnimatedSprite2D.stop()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var velocity=Vector2.ZERO
	
	if can_move :
		#da mouvements
		if (Input.is_action_pressed("move_up")) :
			velocity.y=-1
		if (Input.is_action_pressed("move_down")) :
			velocity.y=1
		if (Input.is_action_pressed("move_left")) :
			velocity.x=-1
		if (Input.is_action_pressed("move_right")) :
			velocity.x=1
			
		if (velocity.length()>0 or $AnimatedSprite2D.animation=="hit") :
			velocity=velocity.normalized()
			$AnimatedSprite2D.play()
		elif ($AnimatedSprite2D.animation!="hit" && $AnimatedSprite2D.is_playing()):
			$AnimatedSprite2D.stop()
			
		#if velocity.x!=0 :
			
		if ($AnimatedSprite2D.animation=="hit" && $AnimatedSprite2D.is_playing()) :
			pass
		else:
			if velocity.y!=0 && velocity.x!=0:
				$AnimatedSprite2D.animation="walk3"
				$AnimatedSprite2D.flip_h= velocity.x*velocity.y<0
			elif (!velocity==Vector2.ZERO):
				$AnimatedSprite2D.animation="walk1"
			
			
			
		#position+=delta*velocity*speed
		if knockback_timer<=0:
			self.velocity=velocity*speed
			move_and_slide()
		else :
			knockback_timer-=delta
			self.velocity=knockback_vector
			move_and_slide()
		
	
	
	pass



func take_damage(hit_power,enemy_position) -> void:
	$CollisionShape2D.set_deferred("disabled",true)
	self.health-=hit_power
	$AnimatedSprite2D.animation="hit"
	var direction = (global_position - enemy_position).normalized()
	knockback_vector = direction * 300  # adjust push strength
	knockback_timer=knockback_duration
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.animation = "walk1"
	await get_tree().create_timer(0.5).timeout
	$CollisionShape2D.set_deferred("disabled",false)
	
	#$AnimatedSprite2D.stop()
	pass # Replace with function body.
	
	
func death() -> void :
	can_move=false
	#$AnimatedSprite2D.play("death1")
	$AnimatedSprite2D.animation="death1"
	$AnimatedSprite2D.play()
	$CollisionShape2D.set_deferred("disabled",true)
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.animation="death1"
	$AnimatedSprite2D.frame = 3
	$AnimatedSprite2D.speed_scale=0
	
