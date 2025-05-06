extends RigidBody2D

@export var hit_power=100
var screen_bounds = Rect2(Vector2(-1000,-1000), Vector2(4000, 2500))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")
	#print("Mob scene ready! My position:", global_position)
	#self.FREEZE_MODE_STATIC
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	linear_velocity=linear_velocity
	if not screen_bounds.has_point(self.position):
		queue_free() 
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): 
		print("collision with player!")
		body.hit.emit(hit_power,self.global_position)
	pass # Replace with function body.
