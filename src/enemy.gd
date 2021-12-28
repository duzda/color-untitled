class_name Enemy
extends KinematicBody2D

const ColorType = preload("res://src/color_type.gd")

export (int) var speed = 1200
export (int) var gravity = 4000

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

export (ColorType.ColorType) var behavior_color = ColorType.ColorType.WHITE

const len_delta = 2

var velocity = Vector2()
var player
var prefered_direction = 1
var elapsedTime

func _ready():
	elapsedTime = get_tree().get_root().get_node("ColorManager/GUI/ElapsedTime")


func change_color(new_color):
	self.behavior_color = new_color
	
	if new_color == ColorType.ColorType.RED:
		prefered_direction = 1 if int(elapsedTime.get_time()) % 2 == 1 else -1

	if new_color == ColorType.ColorType.BLACK:
		self.set_collision_layer_bit(0, false)
		self.set_collision_mask_bit(0, false)
		$ColorRect.visible = false
		$Particles2D.emitting = true
	else:
		self.set_collision_layer_bit(0, true)
		self.set_collision_mask_bit(0, true)
		$ColorRect.visible = true
		$Particles2D.emitting = false
		$ColorRect.color = ColorType.get_color(new_color)


func _physics_process(delta):	
	velocity.y += gravity * delta

	if self.behavior_color == ColorType.ColorType.RED:
		# Patrol
		if player == null:
			if $RayCast2DRight.is_colliding() and prefered_direction == 1:
				if $RayCast2DRight.get_collision_point().y - self.position.y < len_delta:
					prefered_direction *= -1
				else:
					velocity.x = lerp(velocity.x, prefered_direction * speed, acceleration)					

			elif $RayCast2DLeft.is_colliding() and prefered_direction == -1:
				if $RayCast2DLeft.get_collision_point().y - self.position.y < len_delta:
					prefered_direction *= -1
				else:
					velocity.x = lerp(velocity.x, prefered_direction * speed, acceleration)

			else:
				prefered_direction *= -1

		# Chase
		else:
			var dir = 1 if player.position.x > self.position.x else -1
			velocity.x = lerp(velocity.x, dir * speed, acceleration)

	elif self.behavior_color == ColorType.ColorType.GREEN:
		# Flee
		if player != null:
			var dir = -1 if player.position.x > self.position.x else 1
			velocity.x = lerp(velocity.x, dir * speed, acceleration)

	# If stationary
	if ((self.behavior_color != ColorType.ColorType.RED and 
		self.behavior_color != ColorType.ColorType.GREEN) or
		(self.behavior_color == ColorType.ColorType.GREEN and
		player == null)):
		velocity.x = lerp(velocity.x, 0, friction)
	
	if self.behavior_color == ColorType.ColorType.WHITE:
		velocity = move_and_slide(velocity, Vector2.UP, true)
	else:
		velocity = move_and_slide(velocity, Vector2.UP)	

	if self.behavior_color == ColorType.ColorType.RED:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("player"):
				var dir = $CollisionShape2D.global_position - collision.collider.get_node("CollisionShape2D").global_position
				collision.collider.shatter(-dir)
				
			if collision.collider.is_in_group("enemy"):
				prefered_direction *= -1

func _on_DetectRadius_body_entered(body):
	player = body

func _on_DetectRadius_body_exited(_body):
	player = null

	if self.behavior_color == ColorType.ColorType.RED:
		prefered_direction = 1 if _body.position.x > self.position.x else -1
