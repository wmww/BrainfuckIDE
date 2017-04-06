extends Control

export(NodePath) var controller_node
var controller

func _ready():
	controller = get_node(controller_node)

func _on_reset_btn_pressed():
	controller.reset()
