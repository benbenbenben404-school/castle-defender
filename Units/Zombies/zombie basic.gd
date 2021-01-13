extends KinematicBody


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var health = 1
var damage = 1
var speed = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$"Forward Check".get_overlapping_areas():
		move_and_slide(Vector3(1,0,0)*speed)
