extends Node

export(NodePath) var data_node
export(NodePath) var terminal_node

# the node that manages and displays the array, set in _ready from data_node
var dataManager
var terminal

# the source code that we are running
var source

# instr is an int: 1- 2+ 3< 4> 5. 6, 7[ 8]
var instr
var instrToStr = {1: '-', 2: '+', 3: '<', 4: '>', 5: '.', 6: ',', 7: '[', 8: ']'}

# some settings to control appearence
var skipToEnd = false
var combineStreak = true
var combineLoop = false
var fasterInLoop = true
const default_enforce_8bit = true
const default_zoom = 0.8

# the index in the source code that we are to run next
# or the length of the source code array if we are done
var instrIndex

# a list of the location of all open brackets that form the stack
var stack

# how much longer we are waiting before we can do something new
var delay

# used to speed things up as 
#var lastOp = 0
#var streak = 0
var defaultBaseOpTime = 0.4
var baseOpTime = defaultBaseOpTime
var time = baseOpTime

func _ready():
	reset()
	dataManager = get_node(data_node)
	terminal = get_node(terminal_node)
	dataManager.setZoom(default_zoom)
	set_process(true)

func addBFSource(sourceIn):
	source += sourceIn
	for i in sourceIn:
		if i == "-":
			instr.append(1)
		elif i == "+":
			instr.append(2)
		elif i == "<":
			instr.append(3)
		elif i == ">":
			instr.append(4)
		elif i == ".":
			instr.append(5)
		elif i == ",":
			instr.append(6)
		elif i == "[":
			instr.append(7)
		elif i == "]":
			instr.append(8)

func _process(delta):
	if instrIndex < instr.size():
		delay -= delta
		var maxIters = 601 # arbitrary number
		if skipToEnd:
			time = 2 * baseOpTime
			var i = 0
			while instrIndex < instr.size() && i < maxIters:
				runNextOp()
				i += 1
			dataManager.blinkOp("...", time)
			delay = time
		elif combineLoop && !stack.empty():
			time = 4 * baseOpTime
			var i = 0
			while !stack.empty() && instrIndex < instr.size() && i < maxIters:
				runNextOp()
				i += 1
			dataManager.blinkOp("[...]", time)
			delay = time
		else:
			if fasterInLoop:
				time = baseOpTime / (stack.size()*3 + 1)
			else:
				time = baseOpTime
			var i = 0
			while delay < 0 && instrIndex < instr.size() && i < maxIters:
				runNextOp()
				i += 1
		
		time = baseOpTime
	else:
		delay = 0
		skipToEnd = false

func runNextOp():
	
		if instrIndex >= instr.size():
			return
		
		var instrI = instrIndex
		
		var c = instr[instrI]
		
		#if c == lastOp:
		#	streak += 1
		#else:
		#	lastOp = c
		#	streak = 0
		
		var iters = 1
		
		if combineStreak && c >= 1 && c <= 4:
			while instr.size() > instrI+1 && instr[instrI+1] == c:
				instrI += 1
				iters += 1
		
		if c == 1:
			dataManager.addVal(-iters, time)
		elif c == 2:
			dataManager.addVal(iters, time)
		elif c == 3:
			dataManager.movePtr(-iters, time)
		elif c == 4:
			dataManager.movePtr(iters, time)
		elif c == 5:
			terminal.addOutput(dataManager.getValAscii())
		elif c == 6:
			var a = terminal.popInput()
			if !a:
				throwError("please enter input")
				a = '\n'
				
			dataManager.setValAscii(a, time)
				
		elif c == 7:
			if dataManager.getVal() == 0:
				instrI = findCloseBrace(instrI)-1
			else:
				stack.append(instrI)
		elif c == 8:
			if stack.size() == 0:
				throwError("']' without '['")
			else:
				if dataManager.getVal() == 0:
					stack.pop_back()
				else:
					instrI = stack.back()
		else:
			throwError("unrecognised command " + str(c))
		
		dataManager.blinkOp(instrToStr[c], time)
		
		delay += time
		
		instrIndex = instrI + 1

func findCloseBrace(start):
	if instr[start] != 7:
		throwError("findCloseBrace called without the starting point being '['")
		return start
	
	var count = 1
	var i = start + 1
	
	while count > 0:
		if i >= instr.size():
			print("could not find matching '['")
			return instr.size()
		
		if instr[i] == 7:
			count += 1
		elif instr[i] == 8:
			count -= 1
		
		i += 1
	
	return i

func setModValue(modVal):
	if !dataManager:
		dataManager = get_node(data_node)
	dataManager.setModValue(modVal)

#func calcTime():
	
	#return baseOpTime
	
	#if streak<3:
	#	return 0.35
	#elif streak<12:
	#	return 0.2
	#else:
	#	return 0.05
	
	#return (0.3*5) / (streak+5)
	
	#return max(0.4 - streak/20.0, 0)
	
	#if streak<3:
	#	return 0.2
	#else:
	#	return 0

func reset():
	source = ""
	instr = []
	instrIndex = 0
	stack = []
	delay = 0
	if dataManager:
		dataManager.reset(baseOpTime*2)
	if terminal:
		terminal.reset()

func throwError(msg):
	print("ERROR: " + msg)
