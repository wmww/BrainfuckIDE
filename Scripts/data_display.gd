extends Control

export(Font) var array_font

class AnimData:
	var startVal
	var endVal
	var totalTime
	var currentTime
	
	func _init(startIn, endIn, timeIn):
		startVal = startIn
		endVal = startIn
		currentTime = 0
		totalTime = 1
		start(endIn, timeIn)
	
	func start(val, time):
		startVal=getVal()
		endVal=val
		totalTime=time
		currentTime=0
	
	func advanceBy(delta):
		currentTime+=delta
		if currentTime>totalTime:
			currentTime=totalTime
	
	func getVal():
		return (endVal-startVal)*currentTime/totalTime+startVal
	
	func isOver():
		return currentTime>=totalTime
	

var data=[0]
var labels=[]
var i=0
var iAnim=AnimData.new(0, 0, 0)
var elemWidth=200

func _ready():
	updateLabels()
	set_process(true)

func _process(delta):
	updateAnim(delta)

func movePtr(offset):
	i+=offset
	if i < 0:
		throwError("you went too far left")
		i=0
	while data.size() <= i:
		data.push_back(0)
	updateLabels()
	
func addVal(amount):
	data[i]+=amount
	updateLabels()
	
func getVal():
	return data

func updateAnim(delta):
	if !iAnim.isOver():
		iAnim.advanceBy(delta)
		get_node("data_holder/current_marker").set_pos(iAnim.getVal())

func updateLabels():
	for j in range(0, data.size()):
		while j >= labels.size():
			addLabel()
		labels[j].set_text(str(data[j]))
	
	iAnim=AnimData.new(get_node("data_holder/current_marker").get_pos(), labels[i].get_pos(), 2)

func addLabel():
	var label = Label.new()
	label.add_font_override("font", array_font)
	label.set_custom_minimum_size(Vector2(200, 0))
	get_node("data_holder").add_child(label)
	label.set_pos(Vector2(elemWidth*labels.size(), 0))
	labels.push_back(label)

func throwError(msg):
	print("ERROR: " + msg)
