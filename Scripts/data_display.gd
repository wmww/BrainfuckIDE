extends Control

var data
var elems
var i=0
var elemSize=Vector2(400, 200)
const ElemScene = preload("res://Scenes/data_elem.tscn")
const AnimData = preload("anim_data.gd")
var offsetAnim = AnimData.new(0)
var zoom = 1

var dataHolder
var marker

func _ready():
	data=[]
	elems=[]
	
	dataHolder = get_node("data_holder")
	marker = get_node("data_holder/marker")
	
	for i in range(0, 24):
		data.append(0)
		addElemDisplay()
	
	moveMarker(0)
	set_process(true)

func _process(delta):
	if !offsetAnim.done():
		offsetAnim.advance(delta)
		dataHolder.set_pos(Vector2(offsetAnim.get(), elemSize.y/2.0))

func movePtr(offset, time):
	i+=offset
	
	if i < 0:
		throwError("you went too far left")
		i=0
	
	while data.size() <= i:
		data.push_back(0)
	
	while elems.size() <= i + 4:
		addElemDisplay()
	
	moveMarker(time)

func moveMarker(time):
	var pos = Vector2(elemSize.x*(i+0.5), elemSize.y/2)
	marker.moveTo(pos, time)
	
	var maxRight = get_size().x - (pos.x + elemSize.x/2) * zoom
	if dataHolder.get_pos().x > maxRight:
		offsetAnim.start(maxRight, time)
	
	var maxLeft = (- pos.x + elemSize.x/2) * zoom
	if dataHolder.get_pos().x < maxLeft:
		offsetAnim.start(maxLeft, time)

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
	marker.blink(opText, time)

func addElemDisplay():
	var elem = ElemScene.instance()
	dataHolder.add_child(elem)
	elem.set_pos(Vector2(elems.size()*elemSize.x, -elemSize.y/2))
	elem.set_size(elemSize)
	elems.push_back(elem)

func reset(time):
	for i in range(0, data.size()):
		data[i] = 0
	
	for i in elems:
		i.changeVal(0, time)
	
	i=0
	
	moveMarker(time)

func setZoom(newZoom):
	var markPos = marker.get_pos().x
	var dataPos = dataHolder.get_pos().x
	var markPosScreen = dataPos + markPos*zoom
	var newOffset = markPosScreen - markPos*newZoom
	if newOffset > 0:
		newOffset = 0
	offsetAnim.start(0, 0)
	dataHolder.set_pos(Vector2(0, elemSize.y/2.0))
	zoom = newZoom
	get_node("data_holder").set_scale(Vector2(newZoom, newZoom))

func throwError(msg):
	print("ERROR: " + msg)
