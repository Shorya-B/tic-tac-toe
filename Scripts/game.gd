extends Node2D



@export var oLabelScene : PackedScene
@export var xLabelScene : PackedScene
@export var winLineScene : PackedScene

@onready var win_label = $WinLabel
@onready var restart_button = $RestartButton

enum x_or_o_or_tie{
	X,
	O,
	TIE
}
var xToShow : bool 
var currentLabels := [] 
var matrixList := [[null,null,null],[null,null,null],[null,null,null]]
var row : int
var column : int
var widthOfBlock := 200
var labelPos : Vector2
var labelWidth := 200
var labelHeigth := 254
var game_running : bool = false




func _ready() -> void:
	restart_button.restart.connect(new_game)
	new_game()

func new_game():
	game_running = true
	xToShow = true
	win_label.hide()
	restart_button.hide()
	matrixList = [[null,null,null],[null,null,null],[null,null,null]]
	for child in get_children():
			
		if not(child == $Background or child == $WinLabel or child == $RestartButton) :
			remove_child(child)
	

	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if game_running:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				showLabel(event.position)
				checkWin()
				checkTie()

func checkTie():
	var flag:= true
	for i in matrixList:
		if null in i:
			flag = false
	if flag:
		stop_game(2)




func showLabel(mousePosition):
	row = int(mousePosition.y/200)
	column = int(mousePosition.x/200)
	labelPos = Vector2(column*widthOfBlock + widthOfBlock/2.0 - labelWidth/2.0, row*widthOfBlock + widthOfBlock/2.0 - labelHeigth/2.0)
	if matrixList[row][column] == null:
		if xToShow:
			var xLabel = xLabelScene.instantiate()
			add_child(xLabel)
			xLabel.position = labelPos
			matrixList[row][column] = x_or_o_or_tie.X
			xToShow = !xToShow
		else:
			var oLabel = oLabelScene.instantiate()
			add_child(oLabel)
			oLabel.position = labelPos
			matrixList[row][column] = x_or_o_or_tie.O
			xToShow = !xToShow


func checkWin():
	# Checks Horizontal Win:
	var checker := 2
	for i in range(matrixList.size()):
		if null not in matrixList[i]:
			for j in range(matrixList[i].size()):				
				if !j :
					checker = matrixList[i][j]
					continue
				elif checker != matrixList[i][j]:
					break
				elif j == (matrixList[i].size() - 1):
					drawWinLine(Vector2(0,i*widthOfBlock + widthOfBlock/2.0),Vector2(widthOfBlock*matrixList.size(), i*widthOfBlock + widthOfBlock/2.0))
					stop_game(checker)
					break
					
	# Checks Vertical Win:
	checker = 2
	for i in range(matrixList[0].size()):
		for j in range(matrixList.size()):
			if !j and matrixList[j][i] != null:
				checker = matrixList[j][i]
				continue
			elif checker != matrixList[j][i]:
				break
			elif j == (matrixList.size() - 1):
				drawWinLine(Vector2(i*widthOfBlock + widthOfBlock/2.0,0),Vector2(i*widthOfBlock + widthOfBlock/2.0, widthOfBlock*matrixList.size(),))
				stop_game(checker)
				break

	# Checks Main Diagonal Win:
	checker = 2
	for i in range(matrixList.size()):
		if !i and matrixList[i][i] != null:
			checker = matrixList[i][i]
			continue
		elif checker != matrixList[i][i]:
			break
		elif i == (matrixList.size() - 1):
				drawWinLine(Vector2(0,0),Vector2(widthOfBlock*matrixList.size(), widthOfBlock*matrixList.size()))
				stop_game(checker)
				break
	# Checks AntiDiagonal Win:
	checker = 2
	for i in range(matrixList.size()):
		if !i and  matrixList[i][matrixList.size()-1-i] != null:
			checker = matrixList[i][matrixList.size()-1-i]
			continue
		elif checker != matrixList[i][matrixList.size()-1-i]:
			break
		elif i == (matrixList.size() - 1):
				drawWinLine(Vector2(widthOfBlock*matrixList.size(), 0),Vector2(0, widthOfBlock*matrixList.size()))
				stop_game(checker)
				break
	
		
		
func drawWinLine(startPoint, endPoint):
	print("Win Line to be drawn!")
	var winLine = winLineScene.instantiate()
	add_child(winLine)
	winLine.set_points(PackedVector2Array([startPoint, endPoint]))
	
	
	
func stop_game(winner):
	game_running = false
	if winner == x_or_o_or_tie.O:
		win_label.text = "O Wins!"
	elif winner == 2:
		win_label.text = "Thats a tie"
	elif winner == x_or_o_or_tie.X:
		win_label.text = "X Wins!"
	win_label.show()
	restart_button.show()
	
