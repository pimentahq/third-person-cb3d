extends Area3D

@export var jump_impulse := 16.0

func _ready() -> void:
	self.connect("body_entered", body_entered)

func body_entered(body: Node3D) -> void:
	if body.is_class("CharacterBody3D"):
		body.velocity.y = jump_impulse
