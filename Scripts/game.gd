extends Node2D



@export var oLabelScene : PackedScene
@export var xLabelScene : PackedScene
@export var winLineScene : PackedScene

enum x_or_o{
	X,
	O
}
var xToShow : bool = true
var currentLabels := [] 
var matrixList := [[null,null,null],[null,null,null],[null,null,null]]
var row : int
var column : int
var widthOfBlock := 200
var labelPos : Vector2
var labelWidth := 200
var labelHeigth := 254




func _ready() -> void:
	print(winLineScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			showLabel(event.position)
			checkWin()


func showLabel(mousePosition):
	row = int(mousePosition.y/200)
	column = int(mousePosition.x/200)
	labelPos = Vector2(column*widthOfBlock + widthOfBlock/2.0 - labelWidth/2.0, row*widthOfBlock + widthOfBlock/2.0 - labelHeigth/2.0)
	if matrixList[row][column] == null:
		if xToShow:
			var xLabel = xLabelScene.instantiate()
			add_child(xLabel)
			xLabel.position = labelPos
			matrixList[row][column] = x_or_o.X
			xToShow = !xToShow
		else:
			var oLabel = oLabelScene.instantiate()
			add_child(oLabel)
			oLabel.position = labelPos
			matrixList[row][column] = x_or_o.O
			xToShow = !xToShow


func checkWin():
	var checker := 2
	for i in range(matrixList.size()):
		if null not in matrixList[i]:
			for j in range(matrixList[i].size()):				
				if !j :
					checker = matrixList[i][j]
					continue
				if checker != matrixList[i][j]:
					break
				if j == (matrixList[i].size() - 1):
					drawWinLine()
					break
	checker = 2
	for i in range(matrixList[0].size()):
		for j in range(matrixList.size()):
			if !j and matrixList[j][i] != null:
				checker = matrixList[j][i]
				continue
			if checker != matrixList[j][i]:
				break
			if j == (matrixList.size() - 1):
				drawWinLine()
				break
		
		
func drawWinLine():
	print("Win Line to be drawn!")
	var winLine = winLineScene.instantiate()
	add_child(winLine)
	winLine.set_points(PackedVector2Array())

	
	
