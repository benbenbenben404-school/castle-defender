
extends KinematicBody


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var health = 1
var damage = 1
var speed = 1
var velocity
export var anim_speed = 1
onready var anim_tree = $"AnimationTree"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_tree.advance(rand_range(0,1)*1.6)
	anim_tree.set("parameters/TimeScale/scale",rand_range(1.4,2.0))
	print(anim_tree.get("parameters/TimeScale/scale"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	if !$"Forward Check".get_overlapping_areas():
	velocity = anim_tree.get_root_motion_transform()
	velocity.origin.y+=0
	move_and_slide(velocity.origin*110)
	#print(velocity.origin*100)
	#anim_tree.advance(delta*10)
	#anim_tree.tree_root.animation = "Run"
	#anim_tree.tree_root.play()

#plz do not fly up thx
