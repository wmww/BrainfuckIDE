extends Control

const AnimData = preload("anim_data.gd")
var val=0
var labelAnim = AnimData.new(val)

const labelOffset=Vector2(200, 100)

func _ready():
	_process(1)
	set_process(true)

func _process(delta):
	if !labelAnim.done():
		labelAnim.advance(delta)
		var l1 = get_node("ctrl1")
		var l0 = get_node("ctrl0")
		if labelAnim.done():
			l1.hide()
			l0.get_child(0).set_text(str(round(val)))
			#l0.set_scale(Vector2(1, 1))
			l0.set_pos(Vector2(0, 0) + labelOffset)
			l0.set_opacity(1)
			set_process(false)
		else:
			l1.show()
			var i = labelAnim.get()
			l0.get_child(0).set_text(str(floor(i)))
			l1.get_child(0).set_text(str(ceil(i)))
			i = i - floor(i)
			
			l0.set_pos(Vector2(0, i*get_size().y*0.5) + labelOffset)
			l0.set_opacity(1-i)
			
			l1.set_pos(Vector2(0, (i-1)*get_size().y*0.5) + labelOffset)
			l1.set_opacity(i)
		
		autoscale(l0)
		autoscale(l1)

func autoscale(ctrl):
	var textln = ctrl.get_child(0).get_text().length()
	var factor = 1
	if textln > 2:
		factor = 2.6 / textln
	
	ctrl.set_scale(Vector2(factor, factor))

func changeVal(newVal, time):
	labelAnim.start(newVal, time)
	set_process(true)
	val=newVal
