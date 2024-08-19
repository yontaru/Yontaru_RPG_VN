extends Control

var dialog = []
var dialog_index = 0
var text_to_display = ""
var rich_text_label = null
var timer = null
var is_text_complete = false  # Nueva bandera para saber si el texto está completo

func _ready():
	load_dialog_from_file("res://Dialogues/chapter1.json")

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if is_text_complete:  # Solo cargar el siguiente diálogo si el texto está completo
			load_dialog()
		else:
			# Completa el texto actual si no está completo
			if rich_text_label and text_to_display:
				rich_text_label.text = text_to_display
				is_text_complete = true
				if timer:
					timer.stop()  # Detén el temporizador si el texto se completa manualmente

func load_dialog_from_file(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_instance = JSON.new()
		var json_data = file.get_as_text()
		var parse_result = json_instance.parse(json_data)
		
		if parse_result == OK:
			var data = json_instance.get_data()
			if data.has("dialogues"):
				dialog = data["dialogues"]
				load_dialog()
			else:
				print("Error: El archivo JSON no contiene la clave 'dialogues'.")
		else:
			print("Error al analizar JSON: %s" % json_instance.get_error_message())
		
		file.close()
	else:
		print("Error al abrir el archivo: %s" % file_path)

func load_dialog():
	if dialog_index < dialog.size():
		var current_dialog = dialog[dialog_index]
		text_to_display = current_dialog["text"]
		
		# Configura el RichTextLabel
		rich_text_label = $DialogueText/RichTextLabel
		rich_text_label.text = ""
		
		# Crea y configura un temporizador para el efecto de escritura
		if timer:
			timer.stop()  # Detén el temporizador anterior si existe
			timer.queue_free()  # Libera los recursos del temporizador anterior

		timer = Timer.new()
		timer.wait_time = 0.03  # Ajusta el tiempo entre cada letra
		timer.autostart = false
		timer.one_shot = false
		add_child(timer)
		
		# Conecta la señal timeout del temporizador
		timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
		
		# Inicia el temporizador
		timer.start()
		
		# Configura el índice del diálogo y la animación de imágenes
		if current_dialog.has("images"):
			load_three_images(current_dialog["images"])
		elif current_dialog.has("image"):
			load_image(current_dialog["image"])
		else:
			clear_images()
		
		is_text_complete = false  # Marca el texto como no completo
		dialog_index += 1
	else:
		queue_free()

func _on_Timer_timeout():
	if rich_text_label and text_to_display:
		if rich_text_label.text.length() < text_to_display.length():
			rich_text_label.text += text_to_display.substr(rich_text_label.text.length(), 1)
		else:
			# Detén el temporizador cuando el texto esté completo
			if timer:
				timer.stop()
			is_text_complete = true  # Marca el texto como completo
			rich_text_label = null  # Limpiar el RichTextLabel después de la animación

func load_three_images(images: Array):
	if images.size() == 3:
		var texture1 = load(images[0]) as Texture
		var texture2 = load(images[1]) as Texture
		var texture3 = load(images[2]) as Texture

		if texture1 and texture2 and texture3:
			var bg = $Background
			if bg:
				var img_exploration = bg.get_node("ImageExploration") as TextureRect
				var img_combat = bg.get_node("ImageCombat") as TextureRect
				var img_mystery = bg.get_node("ImageMystery") as TextureRect

				if img_exploration and img_combat and img_mystery:
					img_exploration.texture = texture1
					img_combat.texture = texture2
					img_mystery.texture = texture3
					
					# Ajusta el tamaño del Background
					var screen_size = get_viewport_rect().size
					bg.size = screen_size
					
					# Ajusta el tamaño y la posición de los nodos aquí
					img_exploration.size = Vector2(screen_size.x / 3, screen_size.y)
					img_combat.size = Vector2(screen_size.x / 3, screen_size.y)
					img_mystery.size = Vector2(screen_size.x / 3, screen_size.y)

					img_exploration.position = Vector2(0, 0) # Posición a la izquierda
					img_combat.position = Vector2(screen_size.x / 3, 0) # Centro
					img_mystery.position = Vector2(2 * (screen_size.x / 3), 0) # Derecha
				else:
					print("Error: No se encontraron los nodos ImageExploration, ImageCombat o ImageMystery.")
			else:
				print("Error: No se encontró el nodo Background.")
		else:
			print("Error: No se pudieron cargar todas las imágenes.")
	else:
		print("Error: La lista de imágenes debe contener exactamente tres rutas.")

func clear_images():
	var bg = $Background
	if bg:
		var img_exploration = bg.get_node("ImageExploration") as TextureRect
		var img_combat = bg.get_node("ImageCombat") as TextureRect
		var img_mystery = bg.get_node("ImageMystery") as TextureRect

		if img_exploration:
			img_exploration.texture = null
		if img_combat:
			img_combat.texture = null
		if img_mystery:
			img_mystery.texture = null

func load_image(image_path: String):
	var texture = load(image_path) as Texture
	if texture:
		var bg = $Background
		if bg:
			var img_exploration = bg.get_node("ImageExploration") as TextureRect
			var img_combat = bg.get_node("ImageCombat") as TextureRect
			var img_mystery = bg.get_node("ImageMystery") as TextureRect

			if img_exploration:
				img_exploration.texture = texture
				img_combat.texture = null
				img_mystery.texture = null
			else:
				print("Error: No se encontró el nodo ImageExploration.")
	else:
		print("Error: No se pudo cargar la imagen.")
