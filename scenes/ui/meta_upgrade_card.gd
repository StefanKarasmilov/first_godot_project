extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player = $AnimationPlayer
@onready var progress_bar = %ProgressBar
@onready var purchase_button = %PurchaseButton
@onready var progress_label = %ProgressLabel
@onready var count_label = %CountLabel

var upgrade: MetaUpgrade


func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)


func set_meta_upgrade(upgrade: MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func update_progress():
	var current_cuantity = 0
	if MetaProgression.save_data["meta_upgrade"].has(upgrade.id):
		current_cuantity = MetaProgression.save_data["meta_upgrade"][upgrade.id]["quantity"]
	var is_maxed = current_cuantity == upgrade.max_quantity
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / upgrade.experience_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed: 
		purchase_button.text = "Max"
	progress_label.text = str(currency) + "/" + str(upgrade.experience_cost)
	count_label.text = "x%d" % current_cuantity


func on_purchase_pressed():
	if upgrade == null: return
	
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgression.save()
	# Llama el método "update_progress" en todos los nodos de grupo "meta_upgrade_card"
	get_tree().call_group("meta_upgrade_card", "update_progress")
	animation_player.play("selected")














