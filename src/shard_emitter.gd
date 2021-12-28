extends Node2D
"""
original source: https://www.reddit.com/r/godot/comments/nimkqg/how_to_break_a_2d_sprite_in_a_cool_and_easy_way/
"""
export(int, 200) var nbr_of_shards = 20 #sets the number of break points
export(float) var threshhold = 10.0 #prevents slim triangles being created at the sprite edges
export(float) var min_impulse = 50.0 #impuls of the shards upon breaking
export(float) var max_impulse = 200.0
export(float) var up_impulse = 20.0
export(float) var min_horizontal_variation = -5.0
export(float) var max_horizontal_variation = 5.0
export(float) var time_scale_on_shatter = 0.1
export(float) var time_scale_duration = 1.5
export(Vector2) var normalizing_vector = Vector2(1, 0.2) #impact vector is multiplied by this vector
export var display_triangles = false #debugging: display sprite triangulation

const SHARD = preload("res://prefabs/shard.tscn")

var triangles = []
var shards = []
var _shatter_impact

func _ready() -> void:
	if get_parent() is ColorRect:
		randomize()
		var _rect = get_parent().get_rect()
		var points = []
		#add outer frame points
		points.append(_rect.position)
		points.append(_rect.position + Vector2(_rect.size.x, 0))
		points.append(_rect.position + Vector2(0, _rect.size.y))
		points.append(_rect.end)

		#add random break points
		for i in nbr_of_shards:
			var p = _rect.position + Vector2(rand_range(0, _rect.size.x), rand_range(0, _rect.size.y))
			#move outer points onto rectangle edges
			if p.x < _rect.position.x + threshhold:
				p.x = _rect.position.x
			elif p.x > _rect.end.x - threshhold:
				p.x = _rect.end.x
			if p.y < _rect.position.y + threshhold:
				p.y = _rect.position.y
			elif p.y > _rect.end.y - threshhold:
				p.y = _rect.end.y
			points.append(p)

		#calculate triangles
		var delaunay = Geometry.triangulate_delaunay_2d(points)
		for i in range(0, delaunay.size(), 3):
			triangles.append([points[delaunay[i + 2]], points[delaunay[i + 1]], points[delaunay[i]]])

		#create RigidBody2D shards
		for t in triangles:
			var center = Vector2((t[0].x + t[1].x + t[2].x)/3.0,(t[0].y + t[1].y + t[2].y)/3.0)

			var shard = SHARD.instance()
			shard.position = center + get_parent().rect_size / 2
			shard.set_mode(RigidBody2D.MODE_STATIC)
			shard.hide()
			shards.append(shard)

			#setup polygons & collision shapes
			shard.get_node("Polygon2D").polygon = t
			shard.get_node("Polygon2D").position = -center

			#shrink polygon so that the collision shapes don't overlapp
			var shrunk_triangles = Geometry.offset_polygon_2d(t, -2)
			if shrunk_triangles.size() > 0:
				shard.get_node("CollisionPolygon2D").polygon = shrunk_triangles[0]
			else:
				shard.get_node("CollisionPolygon2D").polygon = t
			shard.get_node("CollisionPolygon2D").position = -center

			shard.position += shard.position * 0.1
			shard.get_node("Polygon2D").color = Color.white
			shard.get_node("Polygon2D").scale = Vector2(0.95, 0.95)
			shard.position -= Vector2(1, 2)


		update()
		call_deferred("add_shards")


func add_shards() -> void:
	for s in shards:
		get_parent().add_child(s)


func shatter(impact_vector, color) -> void:
	_shatter_impact.enable_shader(-impact_vector)
	impact_vector *= normalizing_vector
	Engine.time_scale = time_scale_on_shatter
	randomize()
	get_parent().self_modulate.a = 0
	for s in shards:
		s.get_node("Polygon2D").color = color
		impact_vector.x += rand_range(min_horizontal_variation, max_horizontal_variation)
		var up_force = Vector2.UP * rand_range(0, up_impulse)
		var impulse = rand_range(min_impulse, max_impulse)
		s.set_mode(RigidBody2D.MODE_RIGID)
		s.apply_central_impulse((impact_vector + up_force) * impulse)
		s.get_node("CollisionPolygon2D").disabled = false
		s.show()
	$Timer.start(time_scale_duration * time_scale_on_shatter)
	

func _draw() -> void:
	if display_triangles:
		for i in triangles:
			draw_line(i[0], i[1], Color.red, 1)
			draw_line(i[1], i[2], Color.red, 1)
			draw_line(i[2], i[0], Color.red, 1)


func _on_Timer_timeout():
	Engine.time_scale = 1

func set_parent(var parent):
	_shatter_impact = parent.get_node("Camera2D").get_node("ShatterImpact")

func show_shards():
	for s in shards:
		s.show()

func hide_shards():
	for s in shards:
		s.hide()
