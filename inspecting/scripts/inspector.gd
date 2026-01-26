extends Node3D


@onready var ball = $MeshInstance3D
@export var ray_cast: RayCast3D
@onready var camera = $camera

@onready var screen_size: Vector2 = DisplayServer.screen_get_size()
@onready var center: Vector2 = Vector2(screen_size.x / 2, screen_size.y / 2)
@onready var fov: int = camera.fov


func _physics_process(_delta):
	#get values
	var mouse_position = get_viewport().get_mouse_position()
	var normalised_mouse_position = (mouse_position - center) / center
	
	#set camera rotation
	ray_cast.rotation_degrees.y = -normalised_mouse_position.x * fov / 1.5
	ray_cast.rotation_degrees.x = -normalised_mouse_position.y * fov / 1.5
	
	#set ball location
	if ray_cast.is_colliding():
		var collision_point = ray_cast.get_collision_point()
		ball.global_position = collision_point
	
	
	
	
	
	
	
	
