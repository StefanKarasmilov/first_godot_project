extends CanvasLayer

signal transition_halfway


func transition():
	$AnimationPlayer.play("default")
	await transition_halfway
	$AnimationPlayer.play_backwards("default")


func emit_transition_halfway():
	transition_halfway.emit()















