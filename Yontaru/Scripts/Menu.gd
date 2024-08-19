extends Control

var chapter_1 = preload("res://Scenes/chapter_1.tscn")

func _on_play_pressed() -> void:
	TransitionScene.transition()
	await TransitionScene.on_transition_finished
	get_tree().change_scene_to_packed(chapter_1)


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_Button_mouse_entered():
	$VBoxContainer/Play.modulate = Color(0, 0, 0, 1)
	$VBoxContainer/Options.modulate = Color(0, 0, 0, 1)
	$VBoxContainer/Quit.modulate = Color(0, 0, 0, 1)

func _on_Button_mouse_exited():
	$VBoxContainer/Play.modulate = Color(0, 0, 0.2, 1) # Azul oscuro
	$VBoxContainer/Options.modulate = Color(0, 0, 0.2, 1)
	$VBoxContainer/Quit.modulate = Color(0, 0, 0.2, 1)
