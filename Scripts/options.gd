extends Control

export(NodePath) var controller_node
var controller

func _ready():
	controller = get_node(controller_node)
	get_node("PanelContainer/VBoxContainer/combine_streaks_btn").set_pressed(controller.combineStreak)
	get_node("PanelContainer/VBoxContainer/combine_loops_btn").set_pressed(controller.combineLoop)

func _on_reset_btn_pressed():
	controller.reset()

func _on_combine_streaks_btn_toggled( pressed ):
	controller.combineStreak = pressed

func _on_combine_loops_btn_toggled( pressed ):
	controller.combineLoop = pressed

func speed_btn_pressed(btn):
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
		
func _on_speed_btn_1_toggled( pressed ):
	speed_btn_pressed(1)

func _on_speed_btn_2_toggled( pressed ):
	speed_btn_pressed(2)

func _on_speed_btn_3_toggled( pressed ):
	speed_btn_pressed(3)

func _on_speed_btn_4_toggled( pressed ):
	speed_btn_pressed(4)

func _on_Button_pressed():
	controller.skipToEnd = true
