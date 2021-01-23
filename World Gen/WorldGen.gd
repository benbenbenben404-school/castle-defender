extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var world_size = Vector2(5,5)
export(Resource) var world_lines
var noise =OpenSimplexNoise.new()


var Chunk = preload("res://World Gen/chunk.tscn")
var h
var s
var v
var vertex_pos:Vector3
var terrain_noise
#onready var WorldMesh = $WorldMesh
var thread_pool =[]
# Called when the node enters the scene tree for the first time.
#func _physics_process(delta: float) -> void:
#	for thread in thread_pool:
#		if thread.is_active():
#			thread.wait_to_finish()
func _ready():
	noise.seed=1
	noise.period=0.5

	noise.octaves = 1

	noise.persistence = 0.7

	noise.lacunarity = 20
	#gen_chunk(1)
	gen_world()
func gen_world():
	#gen_chunk([Vector2(1,1),50,Thread.new()])
	for x in range(0,world_size.x):
		for y in range(0,world_size.y):
			thread_pool.append(Thread.new())
			thread_pool[-1].start(self, "gen_chunk", [Vector2(x,y),50,thread_pool[-1]])
			
func gen_chunk(args):
	var vertex_pos:Vector3
	var thread= args[2]

	var chunk_pos = args[0]
	var chunk_size= args[1]

	#print("TES")

	var chunk = Chunk.instance()

	var surfaceTool :=SurfaceTool.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES);
	#print("TES1")
	for x in range(chunk_size+1):
		for z in range(chunk_size+1):

			vertex_pos = Vector3.ZERO

			vertex_pos.x = x+chunk_pos.x*chunk_size-world_size.x*0.5*chunk_size
			vertex_pos.z = z+chunk_pos.y*chunk_size-3*chunk_size
			terrain_noise = noise.get_noise_2d(vertex_pos.x,vertex_pos.z)/2+0.5
			vertex_pos.x +=noise.get_noise_1d(vertex_pos.z)/1+0.5
			vertex_pos.z +=noise.get_noise_1d(vertex_pos.x)/1+0.5
			#world_lines.distance_to_lines(Vector2(chunk_pos.x*chunk_size+x,chunk_pos.y*chunk_size+z))
			#vertex_pos.y = 0
			vertex_pos.y = pow(max(world_lines.distance_to_lines(Vector2(vertex_pos.x,vertex_pos.z)),10),0.5)*30
			surfaceTool.add_vertex(vertex_pos)
	#print("TES2")
	for x in range(0,(chunk_size)*(chunk_size),chunk_size+1):
		
		for z in range(chunk_size):

			surfaceTool.add_index(x+z)
			surfaceTool.add_index(x+1+chunk_size+z)
			surfaceTool.add_index(x+z+1)
			
			surfaceTool.add_index(x+1+chunk_size+z)
			surfaceTool.add_index(x+z+chunk_size+2)
			surfaceTool.add_index(x+z+1)
	#print("TES2.5")
	surfaceTool.deindex()
	surfaceTool.generate_normals()

	#print("TES3")
	chunk.mesh = surfaceTool.commit(chunk.mesh)	
	#print(chunk.mesh)
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(chunk.mesh, 0)
	#print("TES4")
	for i in range(0,mdt.get_face_count()):
		var vertex = [mdt.get_face_vertex(i,0),mdt.get_face_vertex(i,1),mdt.get_face_vertex(i,2)]

		var face_color:Color = Color(0, 0, 0)

		h = (rand_range(0.0,1.0)*10+110)*1.0/360
		s =rand_range(0.6,0.8)
		v=rand_range(0.8,1.0)
		#v = mdt.get_face_normal(i).normalized().dot(Vector3.UP)/2+0.5
		#v = Vector3(world_lines.lines[0].start_pos.x,0,world_lines.lines[0].start_pos.y).distance_to(mdt.get_vertex(vertex[1]))/1000
		#print(world_lines.lines[0].start_pos.x,world_lines.lines[0].start_pos.y)
		face_color = Color.from_hsv(h,s,v)

		mdt.set_vertex_color(vertex[0], face_color)
		mdt.set_vertex_color(vertex[1], face_color)
		mdt.set_vertex_color(vertex[2], face_color)
	#print("TES5")
	chunk.mesh.surface_remove(0)
	mdt.commit_to_surface(chunk.mesh)
#	print("TES6")
	add_child(chunk)
	thread.wait_to_finish()

func _exit_tree():
	for thread in thread_pool:

		thread.wait_to_finish()




func _on_World_tree_exiting() -> void:
	for thread in thread_pool:

		thread.wait_to_finish()
