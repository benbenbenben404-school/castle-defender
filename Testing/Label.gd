extends Label


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var end = Vector2(300,100)

var start = Vector2(100,100)
var x1 = start.x
var x2 = end.x
var y1 = start.y
var y2 = end.y
func distance(start,end,point):
	var A = point.x - start.x
	var B = point.y - start.y
	var C = end.x - start.x
	var D = end.y - start.y
	var dot = A * C + B * D
	var len_sq = C * C + D * D
	var param = -1;
	if (len_sq != 0):
		param = dot / len_sq;

	var xx
	var yy

	if (param < 0) :
		xx = start.x;
		yy = start.y;
	
	elif param > 1:
		xx = end.x;
		yy = end.y;
	
	else :
		xx = start.x + param * C;
		yy = start.y + param * D;
	

	var dx = point.x - xx;
	var dy = point.y - yy;
	return sqrt(dx * dx + dy * dy);

func _process(delta: float) -> void:

	
	text = str(distance(start,end,get_parent().get_global_mouse_position()))

