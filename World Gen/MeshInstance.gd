extends MeshInstance


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var world_size

var noise

var mdt = MeshDataTool.new()
var surfaceTool :=SurfaceTool.new()
var thread = Thread.new()
var h
var s
var v


# Called when the node enters the scene tree for the first time.
func _ready():
	#gen_chunk(1)
	thread.start(self, "gen_chunk",1)

func gen_chunk(sdef):
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES);
	for x in range(chunk_size+1):
		for z in range(chunk_size+1):
			var hill_pos = Vector2(72,72)
			var hill_width = 64
			var hill_height = 24
			var vertex_pos:Vector3

			vertex_pos.x = x+chunk_pos.x*chunk_size+noise.get_noise_1d(x+chunk_pos.x*chunk_size)
			vertex_pos.z = z+chunk_pos.y*chunk_size+noise.get_noise_1d(z+chunk_pos.y*chunk_size)
			var wideY = noise.get_noise_2d(vertex_pos.x,vertex_pos.y)/2+0.5
			var distance_to_hill = Vector2(vertex_pos.x,vertex_pos.z).distance_to(hill_pos)
			if distance_to_hill < hill_width:
				vertex_pos.y=(1-pow(distance_to_hill,1.5)/pow(hill_width,1.5))*hill_height
			else: 
				vertex_pos.y=0
			vertex_pos.y = float(noise.get_noise_2d(vertex_pos.x/100,vertex_pos.z/100))*100
			surfaceTool.add_vertex(vertex_pos)
	
	for x in range(0,(chunk_size)*(chunk_size),chunk_size+1):
		
		for z in range(chunk_size):

			surfaceTool.add_index(x+z)
			surfaceTool.add_index(x+1+chunk_size+z)
			surfaceTool.add_index(x+z+1)
			
			surfaceTool.add_index(x+1+chunk_size+z)
			surfaceTool.add_index(x+z+chunk_size+2)
			surfaceTool.add_index(x+z+1)

	surfaceTool.generate_normals()


	mesh = surfaceTool.commit();	

	mdt.create_from_surface(mesh, 0)

	for i in range(0,mdt.get_face_count()):
		var vertex = [mdt.get_face_vertex(i,0),mdt.get_face_vertex(i,1),mdt.get_face_vertex(i,2)]

		var face_color:Color = Color(0, 0, 0)
		var heigth =1
		h = 100*1.0/360
		s =rand_range(0.75,0.8)
		v = mdt.get_face_normal(i).normalized().dot(Vector3.UP)/2+0.5
		face_color = Color.from_hsv(h,s,v)

		mdt.set_vertex_color(vertex[0], face_color)
		mdt.set_vertex_color(vertex[1], face_color)
		mdt.set_vertex_color(vertex[2], face_color)
	var color_time_end = OS.get_unix_time()

	mesh.surface_remove(0)
	mdt.commit_to_surface(mesh)
	thread.wait_to_finish()



func _on_Chunk_tree_exiting() -> void:
	thread.wait_to_finish()
