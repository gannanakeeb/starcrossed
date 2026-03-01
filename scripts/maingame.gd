extends Node2D

const SNAKE=0
const APPLE=1
var apple_pos
var snake_body = [Vector2i(5,10),Vector2i(4,10),Vector2i(3,10)]
var snake_direction = Vector2i(1,0)
var add_apple = false
var screen_size
func _ready():
	get_window().move_to_center()
	# 2. Update screen size and position the score
	screen_size = get_viewport_rect().size

	apple_pos= place_apple()
	draw_apple()
	draw_snake()
func place_apple():
	randomize()
	var x = randi() %20
	var y = randi() %20
	return Vector2i(x,y)
	
func draw_apple():
	$"snake apple".set_cell(apple_pos, 1, Vector2i(0, 0))
	
func draw_snake():
	for block in snake_body:
		$"snake apple".set_cell(block,0,Vector2i(7,0))
	for block_index in snake_body.size():
		var block = snake_body[block_index]
		
		if block_index == 0:
			var head_dir = relation2(snake_body[0],snake_body[1])
			if head_dir == 'right': 
				$"snake apple".set_cell(block,0,Vector2i(3,1))
			if head_dir == 'left': 
				$"snake apple".set_cell(block,0,Vector2i(2,0))
			if head_dir == 'top': 
				$"snake apple".set_cell(block,0,Vector2i(3,0))
			if head_dir == 'bottom': 
				$"snake apple".set_cell(block,0,Vector2i(2,1))
		elif block_index == snake_body.size() - 1:
			var tail_dir = relation2(snake_body[-1],snake_body[-2])
			if tail_dir == 'right': 
				$"snake apple".set_cell(block,0,Vector2i(0,0))
			if tail_dir == 'left': 
				$"snake apple".set_cell(block,0,Vector2i(1,0))
			if tail_dir == 'top': 
				$"snake apple".set_cell(block,0,Vector2i(1,1))
			if tail_dir == 'bottom': 
				$"snake apple".set_cell(block,0,Vector2i(0,1))
		
		else:
			var previous_block = snake_body[block_index + 1] - block
			var next_block = snake_body[block_index - 1] - block
			
			if previous_block.x == next_block.x:
				$"snake apple".set_cell(block,0,Vector2i(4,1))
			elif previous_block.y == next_block.y:
				$"snake apple".set_cell(block,0,Vector2i(4,0))
			else:
				if previous_block.x == -1 and next_block.y == -1 or next_block.x == -1 and previous_block.y == -1:
					$"snake apple".set_cell(block,0,Vector2i(6,1))
				if previous_block.x == -1 and next_block.y == 1 or next_block.x == -1 and previous_block.y == 1:
					$"snake apple".set_cell(block,0,Vector2i(6,0))
				if previous_block.x == 1 and next_block.y == -1 or next_block.x == 1 and previous_block.y == -1:
					$"snake apple".set_cell(block,0,Vector2i(5,1))
				if previous_block.x == 1 and next_block.y == 1 or next_block.x == 1 and previous_block.y == 1:
					$"snake apple".set_cell(block,0,Vector2i(5,0))


func relation2(first_block:Vector2i,second_block:Vector2i):
	var block_relation = second_block - first_block
	if block_relation == Vector2i(-1,0): return 'left'
	if block_relation == Vector2i(1,0): return 'right'
	if block_relation == Vector2i(0,1): return 'bottom'
	if block_relation == Vector2i(0,-1): return 'top'
	
func move_snake():
	delete_tiles(SNAKE)
	# 1. Calculate and add the NEW head first
	var new_head = snake_body[0] + snake_direction
	snake_body.insert(0, new_head)
	# 2. Decide if we need to remove the tail
	if add_apple:
		# We ATE an apple! Don't remove the tail so the snake grows.
		add_apple = false 
	else:
		# Normal move: Remove the last piece so the length stays the same.
		# This replaces the need for 'slice'.
		snake_body.remove_at(snake_body.size() - 1)
		
func delete_tiles(id:int):
	var cells = $"snake apple".get_used_cells()
	for cell in cells:
		# Check if the tile at this spot matches the ID we want to delete
		if $"snake apple".get_cell_source_id(cell) == id:
			$"snake apple".set_cell(cell, -1)
			
		
func _input(event):
	if Input.is_action_just_pressed("ui_up"): 
		if not snake_direction == Vector2i(0,1):
			snake_direction = Vector2i(0,-1)
	if Input.is_action_just_pressed("ui_right"): 
		if not snake_direction == Vector2i(-1,0):
			snake_direction = Vector2i(1,0)
	if Input.is_action_just_pressed("ui_left"): 
		if not snake_direction == Vector2i(1,0):
			snake_direction = Vector2i(-1,0)
	if Input.is_action_just_pressed("ui_down"): 
		if not snake_direction == Vector2i(0,-1):
			snake_direction = Vector2i(0,1)
			
func check_apple_eaten():
	if apple_pos == snake_body[0]:
		apple_pos = place_apple()
		add_apple = true
		get_tree().call_group('scoregroup','update_score',20)
func check_game_over():
	var head = snake_body[0]
	# snake leaves the screen
	if head.x > 20 or head.x < 0 or head.y < 0 or head.y > 20:
		reset()
	for block in snake_body.slice(1,snake_body.size() - 1):
		if block == head:
			reset()

func reset():
	snake_body = [Vector2i(5,10),Vector2i(4,10),Vector2i(3,10)]
	snake_direction = Vector2i(1,0)

func _on_timer_timeout() :
	move_snake()
	draw_apple()
	draw_snake()
	check_apple_eaten()
	check_game_over()
func _process(delta):
	check_game_over()
	
func _on_button_pressed() :
	get_window().size = Vector2i(1280, 720)
	get_window().move_to_center()
	get_tree().paused = false
	
	# 3. Destroy this mini-game. You will instantly be back in the main game!
	queue_free()
