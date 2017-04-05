extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var data=[0]
var i=0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func movePtr(offset):
	i+=offset
	if i < 0:
		throwError("you went too far left")
		i=0
	while data.size() < i:
		data.push_back(0)
	updateDisplay()
	
func addVal(amount):
	data[i]+=amount
	updateDisplay()
	
func getVal():
	return data

func updateDisplay():
	var dataStr=""
	for i in data:
		print(i)
		dataStr += str(i) + "    "
	get_node("data_label").set_bbcode(dataStr)

func throwError(msg):
	print("ERROR: " + msg)
