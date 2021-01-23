extends Camera


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var mouse_sensitivity=0.002
export var camera_speed=10
var enabled = false
var direction
var global_direction
# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if enabled:
		direction = Vector3.ZERO
		global_direction = Vector3.ZERO
		if Input.is_action_pressed("w"):
			direction.z +=-1 
		if Input.is_action_pressed("s"):
			direction.z +=1
		if Input.is_action_pressed("a"):
			direction.x +=-1 
		if Input.is_action_pressed("d"):
			direction.x +=1 			 


		if Input.is_action_pressed("down"):
			direction.y +=1
		if Input.is_action_pressed("up"):
			direction.y +=-1			
		global_translate(global_direction*camera_speed*delta)	
		translate(direction*camera_speed*delta)
	transform.orthonormalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && enabled:
		print(-event.relative.x)
		rotate(Vector3(0,1,0),-event.relative.x * mouse_sensitivity)
		rotate(transform.basis.x,-event.relative.y * mouse_sensitivity)
	elif event.is_action_pressed("dev_cam_toggle"):
		if enabled:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			enabled = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			enabled = true
