
var startVal
var endVal
var totalTime
var currentTime

func _init(startIn):
	startVal = startIn
	endVal = startIn
	currentTime = 0
	totalTime = 1

func start(val, time):
	startVal=get()
	endVal=val
	totalTime=time
	currentTime=0

func advance(delta):
	currentTime+=delta
	if currentTime>totalTime:
		currentTime=totalTime

func get():
	if totalTime <= 0:
		return endVal
	else:
		return (endVal-startVal)*currentTime/totalTime+startVal

func done():
	return currentTime>=totalTime
