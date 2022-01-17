extends Control

export(NodePath) var controller_node
export(NodePath) var combine_streaks_node
export(NodePath) var combine_loops_node
export(NodePath) var faster_in_loop_node
export(NodePath) var enforce_8bit_node
export(NodePath) var zoom_slider
var controller
var isModifyingOtherButtonStates

func _ready():
	controller = get_node(controller_node)
	get_node(combine_streaks_node).set_pressed(controller.combineStreak)
	get_node(combine_loops_node).set_pressed(controller.combineLoop)
	get_node(faster_in_loop_node).set_pressed(controller.fasterInLoop)
	get_node(enforce_8bit_node).set_pressed(controller.default_enforce_8bit)
	get_node(zoom_slider).set_value(controller.default_zoom)

func _on_reset_btn_pressed():
	controller.reset()

func _on_enforce_8bit_btn_toggled( pressed ):
	if pressed:
		controller.setModValue(256)
	else:
		controller.setModValue(null)

func _on_combine_streaks_btn_toggled( pressed ):
	controller.combineStreak = pressed

func _on_combine_loops_btn_toggled( pressed ):
	controller.combineLoop = pressed

func _on_faster_in_loop_btn_toggled( pressed ):
	controller.fasterInLoop = pressed

func speed_btn_pressed(btn):
	isModifyingOtherButtonStates = true
	get_node("PanelContainer/VBoxContainer/HBoxContainer/speed_btn_1").set_pressed(btn == 1)
	get_node("PanelContainer/VBoxContainer/HBoxContainer/speed_btn_2").set_pressed(btn == 2)
	get_node("PanelContainer/VBoxContainer/HBoxContainer/speed_btn_3").set_pressed(btn == 3)
	get_node("PanelContainer/VBoxContainer/HBoxContainer/speed_btn_4").set_pressed(btn == 4)
	
	if btn == 1:
		controller.baseOpTime = controller.defaultBaseOpTime / 0.5
	elif btn == 2:
		controller.baseOpTime = controller.defaultBaseOpTime
	elif btn == 3:
		controller.baseOpTime = controller.defaultBaseOpTime / 4.0
	else:
		controller.baseOpTime = controller.defaultBaseOpTime / 20.0
	isModifyingOtherButtonStates = false
		
func _on_speed_btn_1_toggled( pressed ):
	if not isModifyingOtherButtonStates:
		speed_btn_pressed(1)

func _on_speed_btn_2_toggled( pressed ):
	if not isModifyingOtherButtonStates:
		speed_btn_pressed(2)

func _on_speed_btn_3_toggled( pressed ):
	if not isModifyingOtherButtonStates:
		speed_btn_pressed(3)

func _on_speed_btn_4_toggled( pressed ):
	if not isModifyingOtherButtonStates:
		speed_btn_pressed(4)

func _on_Button_pressed():
	controller.skipToEnd = true
	speed_btn_pressed(2)
	
func _on_zoom_slider_value_changed( value ):
	if controller.dataManager:
		controller.dataManager.setZoom(value)

