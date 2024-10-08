extends Node

@export var sword_ability: PackedScene

@onready var timer = $Timer

const MAX_RANGE = 150

var base_damage = 5
var additional_damage_percent = 1
var base_wait_time


func _ready():
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
		# Comprobamos la raiz cuadrada de la distancia entro el enemigo y el jugador
		# en base a la raíz cuadrada del MAX_RANGE
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
	# Ordena por enemigo más cercano al jugador
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = base_damage * additional_damage_percent
	
	sword_instance.global_position = enemies[0].global_position
	# Le añade una posición aleatoria antes de atacar al enemigo para que el "enemy_direction" funcione
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
		timer.wait_time = base_wait_time * (1 - percent_reduction)
		timer.start()
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * .15)
		





