extends CanvasLayer

@onready var continue_button = %ContinueButton
@onready var quit_button = %QuitButton
@onready var title_label = %TitleLabel
@onready var description_label = %DescriptionLabel
@onready var panel_container = %PanelContainer
@onready var victory_stream_player = $VictoryStreamPlayer
@onready var defeat_stream_player = $DefeatStreamPlayer


func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	continue_button.pressed.connect(on_continue_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func set_defeat():
	title_label.text = "Defeat"
	description_label.text = "You lost!"
	play_jingle(true)


func play_jingle(defeat:= false):
	if defeat:
		defeat_stream_player.play()
	else:
		victory_stream_player.play()


func on_continue_button_pressed():
	#ScreenTransition.transition()
	#await ScreenTransition.transition_halfway
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")


func on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")











