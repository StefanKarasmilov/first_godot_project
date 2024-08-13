extends Camera2D

var target_position = Vector2.ZERO

func _ready():
	# Le dice que va a ser ésta camara la que se utilice.
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target()
	# https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
	# En resumen se usa de esta manera para que la camara sea más natural y smooth
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))
	
	
func acquire_target():
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		target_position = player.global_position
