extends Resource
class_name WorldGenLines

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var lines = {
	0:{
		"start_pos":Vector2(0,0),
		"end_pos":Vector2(100,0),
		"depth":0
	}
	
}
var linesCopy=lines
var childlessLines=[]
#var line = {
#	start_pos:vector2
#	end_pos:
#	length:
#	angle:
#	parent:
#	children:
#	width
#}
var root_pos = Vector2(0,0)
export var tree_depth = 7
var branch_no =0 
var start_pos
var end_pos
var angle
var length
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	rand_seed(10)
	for level in range(tree_depth):
		childlessLines = []
		for line in lines:
			if !lines[line].has("children"):
				childlessLines.append(line)
		for line in childlessLines:
			lines[line]["children"]=[]
			for i in range(randi()%int(ceil(10.0/(level+1)))/3+1):
				branch_no+=1
				lines[line]["children"].append(branch_no)
				
				start_pos = lines[line]["end_pos"]
				length = randi()%300+100
				angle = 0.5*PI+(randf()-0.5)*PI *0.7
				end_pos=start_pos +length *Vector2(cos(angle), sin(angle))
				lines[branch_no]={
					"start_pos":start_pos,
					"end_pos":end_pos,
					"depth":level
				}
				print(end_pos)
		linesCopy=lines
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func distance(x,y):
	var distance = 1000	
	var distance_to_line = 1000	

	for line in lines:
		var start = lines[line]["start_pos"]
		var end = lines[line]["end_pos"]
		distance_to_line = abs((end.x-start.x)*(start.y-y) - (start.x-x)*(end.y-start.y)) / sqrt(pow(end.x-start.x,2) + pow(end.y-start.y,2))
		distance = min(distance,distance_to_line)
	return distance
