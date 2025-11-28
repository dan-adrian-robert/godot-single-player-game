extends Camera2D

@onready var hoodMap = $"../HoodMap"

# Zoom settings
var zoom_step := 0.1
var min_zoom := 0.2
var max_zoom := 0.7

# Drag settings
var dragging := false
var last_mouse_position := Vector2.ZERO

# Map boundaries (calculated from HoodMap)
var map_size := Vector2.ZERO
var viewport_size := Vector2.ZERO

# Edge resistance strength (0 = no resistance, 1 = hard clamp)
const EDGE_RESISTANCE := 0.1

# Keyboard movement
const MOVE_SPEED := 1700  # Pixels per second (adjust as needed)

func _ready():
	# Get map size based on HoodMap's texture and scale
	var texture_size = hoodMap.texture.get_size()
	map_size = texture_size * hoodMap.scale
	viewport_size = get_viewport_rect().size
	print(map_size)


func _unhandled_input(event):
	# Zoom with mouse wheel
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_zoom_camera(1.0 - zoom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_zoom_camera(1.0 + zoom_step)

func _process(delta):
	_handle_keyboard_input(delta)
	_apply_edge_resistance(delta)

func _handle_keyboard_input(delta):
	var direction := Vector2.ZERO

	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		direction.x += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		position += direction * MOVE_SPEED * delta

func _zoom_camera(factor):
	zoom *= factor
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y, min_zoom, max_zoom)

func _apply_edge_resistance(delta):
	# Calculate half the visible area
	var half_screen = viewport_size * 0.5 * zoom

	# Set min/max positions based on map size and screen size
	var min_pos = half_screen
	var max_pos = map_size - half_screen

	# Smoothly correct position if out of bounds
	var corrected_pos = position
	if position.x < min_pos.x:
		corrected_pos.x = lerp(position.x, min_pos.x, EDGE_RESISTANCE)
	elif position.x > max_pos.x:
		corrected_pos.x = lerp(position.x, max_pos.x, EDGE_RESISTANCE)

	if position.y < min_pos.y:
		corrected_pos.y = lerp(position.y, min_pos.y, EDGE_RESISTANCE)
	elif position.y > max_pos.y:
		corrected_pos.y = lerp(position.y, max_pos.y, EDGE_RESISTANCE)

	position = corrected_pos
