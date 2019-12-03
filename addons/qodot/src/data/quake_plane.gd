class_name QuakePlane

# Resource representation of a .map file brush plane

var vertices = [Vector3.ZERO, Vector3.RIGHT, Vector3.DOWN]
var texture
var uv
var rotation
var scale
var surface
var content
var color
var hexen_2_param

func _init(
	vertices: PoolVector3Array,
	texture: String,
	uv: PoolRealArray,
	rotation: float,
	scale: Vector2,
	surface: int,
	content: int,
	color: int,
	hexen_2_param: int
	):
	self.vertices = vertices
	self.texture = texture
	self.uv = uv
	self.rotation = rotation
	self.scale = scale
	self.surface = surface
	self.content = content
	self.color = color
	self.hexen_2_param = hexen_2_param

# Get the plane's normal
static func get_normal(plane) -> Vector3:
	var v0 = (plane.vertices[2] - plane.vertices[0]).normalized()
	var v1 = (plane.vertices[1] - plane.vertices[0]).normalized()
	return v0.cross(v1).normalized()

# Get the plane's distance from the world origin
static func get_distance(plane) -> float:
	var normal = get_normal(plane)
	return plane.vertices[0].dot(normal)

# Intersect three brush planes to form a vertex
static func intersect_planes(plane1, plane2, plane3, epsilon: float = 0.0001):
	var n1 = get_normal(plane1)
	var d1 = get_distance(plane1)
	var n2 = get_normal(plane2)
	var d2 = get_distance(plane2)
	var n3 = get_normal(plane3)
	var d3 = get_distance(plane3)

	var m1 = Vector3(n1.x, n2.x, n3.x)
	var m2 = Vector3(n1.y, n2.y, n3.y)
	var m3 = Vector3(n1.z, n2.z, n3.z)
	var d = Vector3(d1, d2, d3)

	var u = m2.cross(m3)
	var v = m1.cross(d)

	var denom = m1.dot(u)

	if(abs(denom) < epsilon):
		return null

	return Vector3(d.dot(u) / denom, m3.dot(v) / denom, -m2.dot(v) / denom)