extends Control


func _on_shop_button_down() -> void:
	pass # Replace with function body.

func _on_start_button_down() -> void:
	get_tree().get_first_node_in_group("MainNode").start()
	hide()

func _on_quit_button_down() -> void:
	pass # Replace with function body.
