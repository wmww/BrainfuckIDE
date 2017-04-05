extends Control

const AnimData = preload("anim_data.gd")
var val=0
var labelAnim = AnimData.new(val)

func _ready():
	setDisplayedVal(val)
	set_process(true)
	pass

func _process(delta):
	if !labelAnim.done():
		labelAnim.advance(delta)
		setDisplayedVal(round(labelAnim.get()))

func changeVal(newVal, time):
	labelAnim.start(newVal, time)

func setDisplayedVal(newVal):
	if val!=newVal:
		val=newVal
		get_node("label0").set_text(str(val))
