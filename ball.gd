extends Node2D

const MOTION_SPEED = 160
var isRunning = false
var direction = Vector2(-2, -1)
var straight = 1
var points = 0
var curr = Vector2()
var firstPos = Vector2()

var tilemap
var ballTex

func _ready():
	ballTex = preload("res://assets/ball.tex")
	tilemap = get_parent().get_node("TileMap")
	drawLevel()

#func _fixed_process(delta):

func _process(delta):
	if (curr.x - firstPos.x) < 30:
		generateRandTiles(200)
	
	if(isRunning):
		var motion = get_pos()
		
		curr = tilemap.world_to_map(get_pos())
		
		#GAME OVER
		if(tilemap.get_cellv(curr) == -1):
			set_process(false)
			set_process_input(false)
			isRunning = false
			get_node("anim").play("explode")
			get_node("../sound").play("sound_game_over")
			get_node("hud/game_over").show()
			
		motion += direction*MOTION_SPEED*delta
		
		set_pos(motion)

func _input(ev):
	if (ev.type==InputEvent.MOUSE_BUTTON):
		if ev.is_pressed():
			if(isRunning == false):
				get_node("hud/tap_label").hide()
				isRunning = true
				return
			
			points += 1
			get_node("hud/points_label").set_text(str(points))
			get_parent().get_node("sound").play("sound_point")
			straight *= -1
			if straight == 1:
				direction = Vector2(-2, -1)
			else:
				direction = Vector2(2, -1)

func drawLevel():
	points = 0
	get_node("hud/points_label").set_text("0")
	direction = Vector2(-2, -1)
	straight = 1
	tilemap.clear()
	var startPos = tilemap.world_to_map(Vector2(0, get_viewport_rect().size.y))
	firstPos = startPos+Vector2(-2, -2)
	tilemap.set_cellv(startPos, 0)
	tilemap.set_cellv(startPos+Vector2(-1, 0), 0)
	tilemap.set_cellv(startPos+Vector2(-2, 0), 0)
	tilemap.set_cellv(startPos+Vector2(0, -1), 0)
	tilemap.set_cellv(startPos+Vector2(0, -2), 0)
	tilemap.set_cellv(startPos+Vector2(-1, -1), 0)
	tilemap.set_cellv(startPos+Vector2(-2, -1), 0)
	tilemap.set_cellv(startPos+Vector2(-1, -2), 0)
	tilemap.set_cellv(firstPos, 0)
	
	generateRandTiles(200)
	
	set_texture(ballTex)
	set_pos(tilemap.map_to_world(startPos))
	
	get_node("hud/tap_label").show()
	#set_fixed_process(true)
	set_process(true)
	set_process_input(true)

func generateRandTiles(tileNum):
	randomize()
	var rep0 = 0
	var rep1 = 0
	
	for i in range(tileNum):
		var rand = randi()%2
		if rep0 >= 4:
			rand = 1
		if rep1 >= 4:
			rand = 0
		if rand == 0:
			firstPos += Vector2(-1, 0)
			rep0 += 1
			rep1 = 0
		else:
			firstPos += Vector2(0, -1)
			rep1 += 1
			rep0 = 0
		tilemap.set_cellv(firstPos, 2)