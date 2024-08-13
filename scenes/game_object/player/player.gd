extends CharacterBody2D

@onready var collision_area_2d = $CollisionArea2D
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var hit_random_stream_player = $HitRandomStreamPlayer

var number_colliding_bodies = 0
var base_speed = 0


func _ready():
	base_speed = velocity_component.max_speed
	
	collision_area_2d.body_entered.connect(on_body_entered)
	collision_area_2d.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(delta):
	var movement_vector = get_movement_vector()
	# Normaliza el vector para que siempre sea de length == 1
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	# Hace el flip horizontal en base a la dirección que nos movemos
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
	


func get_movement_vector():
	# El valor obtenido siempre va a ser -1, 0 o 1 de esa manera determinamos hacia donde movernos
	# El valor positivo en el eje X o Y siempre tiene que ser primero el positivo P.J. "move_right"
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_changed():
	GameEvents.emit_player_damage()
	update_health_display()
	hit_random_stream_player.play_random()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		var ability_instance = ability.ability_controller_scene.instantiate()
		abilities.add_child(ability_instance)
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1)



