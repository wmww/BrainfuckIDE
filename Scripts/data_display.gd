extends Control

var data
var elems
var i=0
var elemSize=Vector2(400, 200)
const ElemScene = preload("res://Scenes/data_elem.tscn")
const AnimData = preload("anim_data.gd")
var offsetAnim = AnimData.new(0)

func _ready():
	data=[]
	elems=[]
	
	for i in range(0, 24):
		data.append(0)
		addElemDisplay()
	
	moveMarker(0)
	set_process(true)

func _process(delta):
	if !offsetAnim.done():
		offsetAnim.advance(delta)
		get_node("data_holder").set_pos(Vector2(offsetAnim.get(), 0))

func movePtr(offset, time):
	i+=offset
	
	if i < 0:
		throwError("you went too far left")
		i=0
	
	while data.size() <= i:
		data.push_back(0)
	
	while elems.size() <= i:
		addElemDisplay()
	
	moveMarker(time)

func moveMarker(time):
	var pos = Vector2(elemSize.x*(i+0.5), elemSize.y)
	get_node("data_holder/marker").moveTo(pos, time)
	
	var maxRight = get_size().x - pos.x - elemSize.x/2
	if get_node("data_holder").get_pos().x > maxRight:
		offsetAnim.start(maxRight, time)
	
	var minRight = - pos.x + elemSize.x/2
	if get_node("data_holder").get_pos().x < minRight:
		offsetAnim.start(minRight, time)

func addVal(amount, time):
	data[i] += amount
	elems[i].changeVal(data[i], time)
	
func getVal():
	return data[i]
	
func setVal(newVal, time):
	data[i] = newVal
	elems[i].changeVal(data[i], time)
	
func getValAscii():
	return RawArray([data[i]]).get_string_from_ascii()
	
func setValAscii(newVal, time):
	setVal(newVal.to_ascii()[0], time)
	
func blinkOp(opText, time):
	get_node("data_holder/marker").blink(opText, time)

func addElemDisplay():
	var elem = ElemScene.instance()
	get_node("data_holder").add_child(elem)
	elem.set_pos(Vector2(elems.size()*elemSize.x, 0))
	elem.set_size(elemSize)
	elems.push_back(elem)

func reset(time):
	for i in range(0, data.size()):
		data[i] = 0
	
	for i in elems:
		i.changeVal(0, time)
	
	i=0
	
	moveMarker(time)

func throwError(msg):
	print("ERROR: " + msg)
