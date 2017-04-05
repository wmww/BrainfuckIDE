extends Control

export(Font) var array_font

var data=[0]
var labels=[]
var i=0

func _ready():
	updateDisplay()

func movePtr(offset):
	i+=offset
	if i < 0:
		throwError("you went too far left")
		i=0
	while data.size() <= i:
		data.push_back(0)
	updateDisplay()
	
func addVal(amount):
	data[i]+=amount
	updateDisplay()
	
func getVal():
	return data

func updateDisplay():
	#var dataStr=""
	for j in range(0, data.size()):
		#print(data[i])
		#dataStr += str(data[i]) + "    "
		while j >= labels.size():
			addLabel()
		labels[j].set_text(str(data[j]))
	
	get_node("data_container/h_box/current_marker").set_pos(labels[i].get_pos())
	
	#get_node("data_label").set_bbcode(dataStr)

func addLabel():
	var label = Label.new()
	label.add_font_override("font", array_font)
	label.set_custom_minimum_size(Vector2(200, 0))
	get_node("data_container/h_box").add_child(label)
	labels.push_back(label)
	get_node("data_container/h_box").show()

func throwError(msg):
	print("ERROR: " + msg)
