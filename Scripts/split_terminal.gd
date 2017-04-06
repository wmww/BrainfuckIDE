extends Control

var history = ""
var input = ""

func _ready():
	updateLabel()
	pass

func addOutput(text):
	history+=text
	updateLabel()

func updateLabel():
	get_node("VBoxContainer/Control/MarginContainer/label").set_bbcode(history)

func _on_LineEdit_text_entered(text):
	input += text + "\n"
	history += text + "\n"
	get_node("VBoxContainer/LineEdit").set_text("")
	updateLabel()

func popInput():
	if input.empty():
		return null
	else:
		var out = input[0]
		input = input.substr(1, input.length()-1)
		return out