extends Panel

var assigned: LilGuySkin
@onready var texture: TextureRect = $VBoxContainer/texture
@onready var buy: Button = $VBoxContainer/buy
@onready var l_r_pick: HBoxContainer = $"VBoxContainer/L_R pick"

func _process(_delta: float) -> void:
	if assigned:
		texture.texture = assigned.IdleImage

func _on_buy_button_down() -> void:
	if PlayerData.goldfish >= 5:
		PlayerData.goldfish -= 5
		PlayerData.unlocked_skins.append(assigned.ID)
		buy.hide()
		l_r_pick.show()
