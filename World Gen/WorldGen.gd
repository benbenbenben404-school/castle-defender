tool
extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var world_size = Vector2(100,100)
export(Resource) var world_lines
var noise =OpenSimplexNoise.new()
export var n = 0 setget genchunk1
var mdt = MeshDataTool.new()
var surfaceTool :=SurfaceTool.new()

var h
var s
var v
onready var WorldMesh = $WorldMesh

# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed=1
	noise.period=1000 	

	noise.octaves = 4

	noise.persistence = 0.7

	noise.lacunarity = 20
	#gen_chunk(1)
	gen_chunk()
func genchunk1(value):
	gen_chunk()
func gen_chunk():
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES);
	for x in range(world_size.x+1):
		for z in range(world_size.y+1):

			var vertex_pos:Vector3

			vertex_pos.x = x+noise.get_noise_1d(x)
			vertex_pos.z = z+noise.get_noise_1d(z)
			vertex_pos.y = world_lines.distance(x,z)
			surfaceTool.add_vertex(vertex_pos)
	
	for x in range(0,(world_size.x)*(world_size.x),world_size.x+1):
		
		for z in range(world_size.x):

			surfaceTool.add_index(x+z)
			surfaceTool.add_index(x+1+world_size.x+z)
			surfaceTool.add_index(x+z+1)
			
			surfaceTool.add_index(x+1+world_size.x+z)
			surfaceTool.add_index(x+z+world_size.x+2)
			surfaceTool.add_index(x+z+1)

	surfaceTool.generate_normals()


	WorldMesh.mesh = surfaceTool.commit();	
	print(WorldMesh.mesh)
	
	mdt.create_from_surface(WorldMesh.mesh, 0)

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

	WorldMesh.mesh.surface_remove(0)
	mdt.commit_to_surface(WorldMesh.mesh)






