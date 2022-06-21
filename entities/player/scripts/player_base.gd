extends CharacterBody3D

@export var speed := 5.0
@export var gravity := 9.8
@export var jump_strength := 5.0
@export var number_jumps := 2
@export var mouse_sensitivity := 0.001
@export var zoom_sensitivity := 0.5
@export var zoom_smothiness := 0.1
@export var min_zoom := 1.0
@export var max_zoom := 10.0


@onready var _horizontal_camera_axis: Position3D = $CameraRoot/HorizontalAxis
@onready var _model_root: Node3D = $ModelRoot
@export var rotation_speed := 8.0

var _current_jump := 0
var _h_rot := 0.0
var _direction := Vector3.ZERO



func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	character_movement(delta)



func character_movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# Reset the number of jumps on touch the floor
	if is_on_floor():
		_current_jump = 0

	# Handle Jump.		
	if Input.is_action_just_pressed("a_jump") and _current_jump < number_jumps:
		_current_jump += 1
		
		if velocity.y < jump_strength:
			velocity.y = jump_strength
			

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("a_left", "a_right", "a_up", "a_down")
	_h_rot = _horizontal_camera_axis.get_global_transform().basis.get_euler().y
	
	_direction.x = input_dir.x
	_direction.z = input_dir.y
	_direction = _direction.rotated(Vector3.UP, _h_rot).normalized()
	
	if _direction:
		velocity.x = _direction.x * speed
		velocity.z = _direction.z * speed
		
		var rot = lerp_angle(_model_root.rotation.y, _h_rot, delta * rotation_speed)
		_model_root.rotation.y = rot
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	move_and_slide()
