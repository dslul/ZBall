extends CanvasLayer

func _ready():
	pass

func _on_newgame_btn_pressed():
	get_parent().drawLevel()
	get_node("game_over").hide()

func _on_exit_btn_pressed():
	get_tree().quit()