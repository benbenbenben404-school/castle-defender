tool
extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var LineScene = preload("res://Testing/line.tscn")
export(Resource) var lines
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for line in lines.lines:
		print(line)
		print(lines.lines[line])
		var linescene = LineScene.instance()
		linescene.points = [lines.lines[line]["start_pos"],lines.lines[line]["end_pos"],]
		linescene.default_color = Color.from_hsv(1.0*lines.lines[line]["depth"]/lines.tree_depth,1.0,1.0)
		add_child(linescene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("a"):
		$Camera2D.position.x+=-10
	if Input.is_action_pressed("s"):
		$Camera2D.position.y+=10
	if Input.is_action_pressed("d"):
		$Camera2D.position.x+=10
	if Input.is_action_pressed("w"):
		$Camera2D.position.y+=-10
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEvent:
		if event.is_action_pressed("scroll_down"):
			$Camera2D.zoom =$Camera2D.zoom*0.9
		if event.is_action_pressed("scroll_up"):
			$Camera2D.zoom =$Camera2D.zoom*1.1
