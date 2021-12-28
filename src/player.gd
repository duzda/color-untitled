class_name Player
extends KinematicBody2D

const ColorType = preload("res://src/color_type.gd")

export (int) var speed = 1200
export (int) var jump_speed = -1800
export (int) var gravity = 4000

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

export (float) var black_time = 10
var current_black_time = black_time
var black = false
var blocked_controls = false
var free_jump = true

var velocity: Vector2
var previous_velocity: Vector2
var hit_the_ground: bool

signal on_gameover

func _ready():
	$ColorRect/ShardEmitter.set_parent(self)
	$Camera2D/ShatterImpact.set_parent(self)

func get_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		free_jump = false
	else:
		velocity.x = lerp(velocity.x, 0, friction)


func _physics_process(delta):
	if blocked_controls:
		return

	if black:
		current_black_time -= delta
		if current_black_time < 0:
			self.shatter(Vector2(0, -40), Color.white)

	get_input()
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_cancel"):
		self.shatter(Vector2(0, 0))
	
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor() or free_jump:
			velocity.y = jump_speed
			free_jump = false

	previous_velocity = velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if "behavior_color" in collision.collider:
			if collision.collider.behavior_color == ColorType.ColorType.RED:
				var dir = collision.collider.get_node("CollisionShape2D").global_position - $CollisionShape2D.global_position
				self.shatter(-dir)
		if collision.collider.is_in_group("map_border"):
			self.shatter(Vector2(0, 0))

	# Animations

	if not is_on_floor():
		hit_the_ground = false
		$ColorRect.rect_scale.y = range_lerp(abs(velocity.y), 0, abs(jump_speed), 0.95, 1.1)
		$ColorRect.rect_scale.x = range_lerp(clamp(abs(velocity.y), 0 , abs(jump_speed)), 0, abs(jump_speed), 1.1, 0.9)

	if not hit_the_ground and is_on_floor():
		hit_the_ground = true
		$ColorRect.rect_scale.x = range_lerp(abs(previous_velocity.y), 0, abs(2400), 1.1, 1.2)
		$ColorRect.rect_scale.y = range_lerp(abs(previous_velocity.y), 0, abs(2400), 1.0, 0.8)
		
	$ColorRect.rect_scale.x = lerp($ColorRect.rect_scale.x, 1, 1 - pow(0.01, delta))
	$ColorRect.rect_scale.y = lerp($ColorRect.rect_scale.y, 1, 1 - pow(0.01, delta))


func _on_ColorManager_black_entered():
	black = true
	$ColorRect/AnimationPlayer.play("dissolve", -1, 1 / black_time)
	$ColorRect/ShardEmitter.show_shards()
	current_black_time = black_time

func _on_ColorManager_other_entered():
	$ColorRect.color = Color.white
	$ColorRect/AnimationPlayer.stop()
	$ColorRect.material.set_shader_param("dissolve_value", 1.0)
	if black:
		$ColorRect/ShardEmitter.hide_shards()
	black = false

func set_collision(value: bool):
	self.set_collision_layer_bit(0, value)
	self.set_collision_layer_bit(18, value)
	self.set_collision_layer_bit(19, value)
	self.set_collision_mask_bit(0, value)
	self.set_collision_mask_bit(18, value)
	self.set_collision_mask_bit(19, value)

func shatter(direction_vector: Vector2, color = Color.white):
	blocked_controls = true
	self.set_collision(false)
	emit_signal("on_gameover")
	$ColorRect/ShardEmitter.shatter(direction_vector, color)

func game_won():
	blocked_controls = true
