extends Control

var data
var elems
var i=0
var elemWidth=200
const ElemScene = preload("res://Scenes/data_elem.tscn")

func _ready():
	data=[0]
	elems=[]
	addElemDisplay()
	#set_process(true)

func movePtr(offset):
	i+=offset
	
	if i < 0:
		throwError("you went too far left")
		i=0
	
	while data.size() <= i:
		data.push_back(0)
	
	while elems.size() <= i:
		addElemDisplay()
	
	moveMarker()

func moveMarker():
	var pos = Vector2(elemWidth*i, 0)
	get_node("marker").moveTo(pos, 0)

func addVal(amount):
	data[i]+=amount
	elems[i].changeVal(data[i], 0)
	
func getVal():
	return data[i]

func addElemDisplay():
	var elem = ElemScene.instance()
	get_node("data_holder").add_child(elem)
	elem.set_pos(Vector2(elems.size()*elemWidth, 0))
	elems.push_back(elem)

func throwError(msg):
	print("ERROR: " + msg)
