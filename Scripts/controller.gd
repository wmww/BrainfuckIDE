extends Node

export(NodePath) var data_node

var source = ""
var execIndex = 0
var stack = []
var dataManager
var delay = 0

func _ready():
	dataManager = get_node(data_node)
	set_process(true)

func addBFSource(sourceIn):
	print("got source: " + sourceIn)
	source += sourceIn

func _process(delta):
	delay -= delta
	if delay<0:
		delay = 0
		runNextOp()

func runNextOp():
	
	var isComment = true
	while isComment:
		if execIndex >= source.length():
			return
		
		isComment = false
			
		var c = source[execIndex]
		
		if c == "+":
			dataManager.addVal(1)
		elif c == "-":
			dataManager.addVal(-1)
		elif c == ">":
			dataManager.movePtr(1)
		elif c == "<":
			dataManager.movePtr(-1)
		elif c == "[":
			if dataManager.getVal() == 0:
				execIndex = findCloseBrace(execIndex)-1
			else:
				stack.append(execIndex)
		elif c == "]":
			if stack.size() == 0:
				throwError("']' without '['")
			else:
				if dataManager.getVal() == 0:
					stack.pop_back()
				else:
					execIndex = stack.back()
		else:
			isComment = true
		
		if !isComment:
			dataManager.blinkOp(c)
			delay += 0.4
		
		execIndex += 1

func findCloseBrace(start):
	if source[start] != "[":
		throwError("findCloseBrace called without the starting point being '['")
		return
	
	var count = 1
	var i = start + 1
	
	while count > 0:
		if i > source.length():
			print("could not find matching '['")
			return source.length()
		
		if source[i] == "[":
			count += 1
		elif source[i] == "]":
			count -= 1
		
		i += 1
	
	return i

func throwError(msg):
	print("ERROR: " + msg)