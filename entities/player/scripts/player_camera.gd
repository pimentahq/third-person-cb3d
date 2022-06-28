extends Position3D

@onready var _player: CharacterBody3D = get_parent()
@onready var _horizontal: Node3D = $HorizontalAxis
@onready var _vertical: Node3D = $HorizontalAxis/VerticalAxis
@onready var _spring_arm: SpringArm3D = $HorizontalAxis/VerticalAxis/SpringArm3D

var _h_accelaration: = 0.1
var _v_accelaration: = 0.1

var _cam_rotation_h := 0.0
var _cam_rotation_v := 0.0

@onready var _temp_spring_arm := _spring_arm.spring_length

func _input(event: InputEvent) -> void:
	camera_event(event)
	camera_zoom_input(event)
	toggle_mouse_lock()

func _physics_process(delta: float) -> void:
	camera_rotation(delta)
	camera_zoom_lerp()


func camera_rotation(delta: float) -> void:
	_horizontal.rotation.y = wrapf(_cam_rotation_h * _h_accelaration * delta, 0, deg2rad(360))
	_vertical.rotation.x = wrapf(_cam_rotation_v * _v_accelaration * delta, 0, deg2rad(360))

func camera_zoom_lerp() -> void:
	_spring_arm.spring_length = lerp(_spring_arm.spring_length, _temp_spring_arm, _player.zoom_smothiness)
	
	_spring_arm.spring_length = clamp(_spring_arm.spring_length, _player.min_zoom, _player.max_zoom)	
	_temp_spring_arm = clamp(_temp_spring_arm, _player.min_zoom, _player.max_zoom)
	
func camera_event(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_cam_rotation_h += -event.relative.x
		_cam_rotation_v += -event.relative.y

func camera_zoom_input(_event: InputEvent) -> void:
	var mouse_wheel = Input.get_axis("a_mouse_wheel_down", "a_mouse_wheel_up")
	
	if mouse_wheel:
		_temp_spring_arm -= mouse_wheel * _player.zoom_sensitivity
		

func toggle_mouse_lock() -> void:
	if Input.is_action_just_pressed("a_toggle_mouse_lock"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
