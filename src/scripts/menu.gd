extends Control

@onready var game: Node2D = $"../.."
@onready var parent_layer: CanvasLayer = $".."
@onready var shop: TextureRect = $TextureRect/Shop
@onready var main_menu: TextureRect = $TextureRect/MainMenu
@onready var fish: Label = $TextureRect/Shop/VBoxContainer/price/Fish
@onready var equipbuttons: HBoxContainer = $TextureRect/Shop/VBoxContainer/equipbuttons
@onready var buy: TextureButton = $TextureRect/Shop/VBoxContainer/Buy
@onready var price: HBoxContainer = $TextureRect/Shop/VBoxContainer/price
@onready var icon: TextureRect = $TextureRect/Shop/VBoxContainer/Icon
@onready var equip_left_button: TextureButton = %equip_left
@onready var equip_right_button: TextureButton = %equip_right


var shop_index: int = 2:
	set(value):
		shop_index = wrapi(value, 2, 9)

func _on_start_button_down() -> void:
	parent_layer.hide()
	game.start()

func _on_shop_button_down() -> void:
	fish.text = str(PlayerData.goldfish)
	if PlayerData.goldfish < 5:
		fish.modulate = Color.RED
	else:
		fish.modulate = Color.WHITE
	main_menu.hide()
	shop.show()

func _on_quit_button_down() -> void:
	PlayerData.save_data()
	get_tree().quit()

func _on_buy_button_down() -> void:
	if PlayerData.goldfish >= 5:
		PlayerData.goldfish -= 5
		fish.text = str(PlayerData.goldfish)
		price.hide()
		buy.hide()
		equipbuttons.show()
		equip_left_button.disabled= false
		equip_right_button.disabled= false
		PlayerData.unlocked_skins.append(shop_index)


func _on_equip_left_button_down() -> void:
	if !PlayerData.unlocked_skins.has(shop_index): return
	PlayerData.lilguy1_skin = shop_index
	equip_left_button.disabled= true

func _on_equip_right_button_down() -> void:
	if !PlayerData.unlocked_skins.has(shop_index): return
	PlayerData.lilguy2_skin = shop_index
	equip_right_button.disabled= true

func _on_back_button_down() -> void:
	shop.hide()
	main_menu.show()

func _on_next_button_down() -> void:
	fish.text = str(PlayerData.goldfish)
	if PlayerData.goldfish < 5:
		fish.modulate = Color.RED
	else:
		fish.modulate = Color.WHITE
	shop_index += 1
	icon.texture = PlayerData.SKINS.get(shop_index).IdleImage
	if PlayerData.unlocked_skins.has(shop_index):
		price.hide()
		buy.hide()
		equipbuttons.show()
		equip_left_button.disabled= false
		equip_right_button.disabled= false
	else:
		price.show()
		buy.show()
		equipbuttons.hide()


func _on_prev_button_down() -> void:
	fish.text = str(PlayerData.goldfish)
	if PlayerData.goldfish < 5:
		fish.modulate = Color.RED
	else:
		fish.modulate = Color.WHITE
	shop_index -= 1
	icon.texture = PlayerData.SKINS.get(shop_index).IdleImage
	if PlayerData.unlocked_skins.has(shop_index):
		price.hide()
		buy.hide()
		equipbuttons.show()
		equip_left_button.disabled= false
		equip_right_button.disabled= false
	else:
		price.show()
		buy.show()
		equipbuttons.hide()
