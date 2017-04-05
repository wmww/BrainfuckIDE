extends Node

export(NodePath) var data_node

var source = ""
var execIndex=0

func _ready():
	set_process(true)

func addBFSource(sourceIn):
	print("got source: " + sourceIn)
	source += sourceIn

func _process(delta):
	runNextOp()

func runNextOp():
	var dataManager = get_node(data_node)
	
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
		else:
			isComment = true
		
		if !isComment:
			dataManager.blinkOp(c)
		
		execIndex += 1
