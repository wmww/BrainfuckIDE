
var startVal
var endVal
var totalTime
var currentTime
var isDone

func _init(startIn):
	startVal = startIn
	endVal = startIn
	currentTime = 0
	totalTime = 0
	isDone = false

func start(val, time):
	startVal = get()
	endVal = val
	totalTime = time
	currentTime = 0
	isDone = false

func advance(delta):
	currentTime += delta
	if currentTime >= totalTime:
		isDone = true

func get():
	if isDone || totalTime <= 0:
		return endVal
	else:
		return (endVal-startVal)*currentTime/totalTime+startVal

func done():
	return isDone
