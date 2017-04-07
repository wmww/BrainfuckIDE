extends Control

export(NodePath) var controller_node
var controller

func _ready():
	controller = get_node(controller_node)

func _on_reset_btn_pressed():
	controller.reset()

func _on_combine_streaks_btn_toggled( pressed ):
	controller.combineStreak = pressed

func _on_combine_loops_btn_toggled( pressed ):
	controller.combineLoop = pressed


func _on_HSlider_value_changed( value ):
	controller.baseOpTime = (1-value) * 2 * controller.defaultBaseOpTime
