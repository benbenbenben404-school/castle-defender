extends MeshInstance3D

func _ready():
	var arr = []
	arr.resize(Mesh.ARRAY_MAX)

	# PackedVectorXArrays for mesh construction.
	var verts = PackedVector3Array()
	
	#var uvs = PackedVector2Array()
	#var normals = PackedVector3Array()
	#var indices = PackedInt32Array()

	verts.append(Vector3(0,0,0))
	verts.append(Vector3(10,0,10))
	verts.append(Vector3(0,0,10))

	# Assign arrays to mesh array.
	arr[Mesh.ARRAY_VERTEX] = verts
	#arr[Mesh.ARRAY_TEX_UV] = uvs
	#arr[Mesh.ARRAY_NORMAL] = normals
	#arr[Mesh.ARRAY_INDEX] = indices

	# Create mesh surface from mesh array.
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr) # No blendshapes or compression used.
