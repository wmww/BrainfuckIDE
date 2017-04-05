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
	
	while true:
		if execIndex >= source.length():
			return
			
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
			pass
		
		execIndex += 1
