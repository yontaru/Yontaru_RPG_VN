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
