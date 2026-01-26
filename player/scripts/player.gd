extends CharacterBody3D



@onready var sprite = $Sprite3D
@export var camera :Camera3D
@export var camera_position_holder :Marker3D


var input_direction := Vector2.ZERO
var accell := 48
var friction := 10

var gravity := 9.8

var camera_sensitivity := 0.12


enum STATES {
	MOVING,
	INTERACTING
}

var state: STATES = STATES.MOVING


enum CHARACTERS{
	RACCOON,
	DOG,
	CROW,
	RABBIT
}

var character: CHARACTERS = CHARACTERS.CROW




@export var raccoon_sprite: Texture
@export var dog_sprite: Texture
@export var crow_sprite: Texture
@export var rabbit_sprite: Texture


func _input(event):
	#camera movement
	if event is InputEventMouseMotion:
		if state == STATES.MOVING:
			rotation_degrees.y += -event.relative.x * camera_sensitivity
			camera_position_holder.rotation_degrees.x += -event.relative.y * camera_sensitivity
			camera_position_holder.rotation_degrees.x = clamp(camera_position_holder.rotation_degrees.x, -70, 20)


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	change_character(CHARACTERS.RACCOON)


func _physics_process(delta):
	match state:
		STATES.MOVING: moving(delta)
		STATES.INTERACTING: interacting(delta)
	
	
	#gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	move_and_slide()


func moving(delta):
	input_direction = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	velocity += ((direction * accell) - (Vector3(velocity.x, 0, velocity.z) * friction)) * delta


func interacting(delta):
	velocity -= Vector3(velocity.x, 0, velocity.z) * friction * delta


func change_state(new_state):
	match new_state:
		STATES.MOVING: 
			state = STATES.MOVING
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		STATES.INTERACTING:
			state = STATES.INTERACTING
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func change_character(new_character: CHARACTERS):
	if state != STATES.MOVING:
		return
	
	character = new_character
	
	match character:
		CHARACTERS.RACCOON: sprite.texture = raccoon_sprite
		CHARACTERS.DOG: sprite.texture = dog_sprite
		CHARACTERS.CROW: sprite.texture = crow_sprite
		CHARACTERS.RABBIT: sprite.texture = rabbit_sprite
	
	
	
