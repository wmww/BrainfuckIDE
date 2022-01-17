extends Control

var data
var elems
# Maximal ideal of the residue field representing all possible values
# Used for the strict mode that enforces positive, 8-bit values (mod 256)
var modValue = null
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
		dataHolder.set_position(Vector2(offsetAnim.__get(), elemSize.y/2.0))

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
	if dataHolder.get_position().x > maxRight:
		offsetAnim.start(maxRight, time)
	
	var maxLeft = (- pos.x + elemSize.x/2) * zoom
	if dataHolder.get_position().x < maxLeft:
		offsetAnim.start(maxLeft, time)

func addVal(amount, time):
	data[i] += amount
	wrapValue(i)
	elems[i].changeVal(data[i], time)
	
func getVal():
	return data[i]
	
func setVal(newVal, time):
	data[i] = newVal
	wrapValue(i)
	elems[i].changeVal(data[i], time)
	
func setModValue(modVal):
	if modVal != null && modVal < 2:
		throwError("bad modVal: " + str(modVal));
	modValue = modVal
	
	for index in range(0, data.size()):
		var backup = data[index]
		wrapValue(index)
		if data[index] != backup:
			elems[index].changeVal(data[index], 0.5)
	
func wrapValue(index):
	if modValue == null:
		return # there is nothing to do
	
	if index < 0 || index >= data.size():
		throwError("This field doesn't exist!")
		return
	
	if data[index] >= modValue || data[index] < 0:
		data[index] = (data[index] % modValue + modValue) % modValue
	
func getValAscii():
	return PoolByteArray([data[i]]).get_string_from_ascii()
	
func setValAscii(newVal, time):
	setVal(newVal.to_ascii()[0], time)
	
func blinkOp(opText, time):
	marker.blink(opText, time)

func addElemDisplay():
	var elem = ElemScene.instance()
	dataHolder.add_child(elem)
	elem.set_position(Vector2(elems.size()*elemSize.x, -elemSize.y/2))
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
	var markPos = marker.posAnim.endVal.x
	var dataPos = offsetAnim.endVal
	var markPosScreen = dataPos + markPos*zoom
	var newDataPos = markPosScreen - markPos*newZoom
	if newDataPos > 0:
		newDataPos = 0
	offsetAnim.start(newDataPos, 0)
	zoom = newZoom
	dataHolder.set_scale(Vector2(newZoom, newZoom))
	moveMarker(0)

func throwError(msg):
	print("ERROR: " + msg)

