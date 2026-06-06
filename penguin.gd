extends CharacterBody2D

@onready var animation := $AnimatedSprite2D
@onready var raycast_floor_collision := $RayCast2D
@onready var collision_player := $CollisionShape2D


const ACELERATION_ICE := 800.0
const MAX_SPEED_ICE := 1500.0
const FRICCION_ICE := 10.0
const JUMP_SPEED := 1200.0
const GRAVITY := 30.0

enum STATES {
	DEAD,
	FALL,
	IDLE,
	JUMP,
	RUN,
	WALK
}

var current_state := STATES.IDLE
var speed = 1000.0



func _physics_process(delta: float) -> void:
	var dir = Input.get_axis("left","right")


	movement(dir,delta)
	state_machine(dir)


func movement(direction: float, delta: float):

	if is_on_floor():
		collision_player.position.y = 39.5
		if Input.is_action_just_pressed("jump"):
			velocity.y -= JUMP_SPEED
			collision_player.position.y = 0
		var floor_type = floor_detection_collision()
		match floor_type:
			"dirt":
				if direction != 0:
					velocity.x = speed * direction
					current_state = STATES.WALK
				else:
					velocity.x = 0
			"ice":
				if direction != 0:
					velocity.x = move_toward(velocity.x,MAX_SPEED_ICE * direction, ACELERATION_ICE)
					current_state = STATES.RUN
				else:
					velocity.x = move_toward(velocity.x,0, FRICCION_ICE)
				velocity.x = clamp(velocity.x,-MAX_SPEED_ICE,MAX_SPEED_ICE)
			"iceBox":
				if direction != 0:
					velocity.x = move_toward(velocity.x,MAX_SPEED_ICE * direction * 1.5, ACELERATION_ICE * 1.5)
					current_state = STATES.RUN
				else:
					velocity.x = move_toward(velocity.x,0, FRICCION_ICE)
				velocity.x = clamp(velocity.x,-MAX_SPEED_ICE,MAX_SPEED_ICE)
				
	else:
		velocity.y += GRAVITY
		velocity.x = speed * direction


	move_and_slide()

func state_machine(direction: float):
	if not is_on_floor():
		if velocity.y < 0:
			current_state = STATES.JUMP
		else:
			current_state = STATES.FALL
	else:
		if velocity.x == 0:
			current_state = STATES.IDLE

	if direction < 0:
		animation.flip_h = false
		if collision_player.position.x < 0:
			pass
		else:
			collision_player.position.x = collision_player.position.x * -1
			raycast_floor_collision.position.x = raycast_floor_collision.position.x * -1
	elif direction > 0:
		animation.flip_h = true
		if collision_player.position.x > 0:
			pass
		else:
			collision_player.position.x = collision_player.position.x * -1
			raycast_floor_collision.position.x = raycast_floor_collision.position.x * -1
	else:
		pass


	animations_player()

func animations_player():
	var current_animation := str(STATES.find_key(current_state)).to_lower()
	animation.play(current_animation)


func floor_detection_collision():

	if raycast_floor_collision.is_colliding():
		var floor_collision = raycast_floor_collision.get_collider()
		if floor_collision is TileMapLayer:
			var point_collision = raycast_floor_collision.get_collision_point()
			var adjustment_point = point_collision - (raycast_floor_collision.get_collision_normal() * 4)
			var cel_pos = floor_collision.local_to_map(floor_collision.to_local(adjustment_point))
			var data = floor_collision.get_cell_tile_data(cel_pos)
			if data:
				var tipo = data.get_custom_data("tipo_suelo")
				return tipo
