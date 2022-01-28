extends Control

var history = ""
var input = ""

func _ready():
	updateLabel()
	pass

func addOutput(text):
	if history.length() < 8000:
		history += text
		updateLabel()

func updateLabel():
	$VBoxContainer/Control/MarginContainer/label.set_bbcode(history+"_")

func _on_LineEdit_text_entered(text):
	input += text + "\n"
	history += text + "\n"
	$VBoxContainer/LineEdit.set_text("")
	updateLabel()

func popInput():
	if input.empty():
		return null
	else:
		var out = input[0]
		input = input.substr(1, input.length()-1)
		return out

func reset():
	history = ""
	input = ""
	updateLabel()
