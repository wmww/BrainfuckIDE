extends Control

var history = ""
var currentLine = ""

func _ready():
	set_focus_mode(Control.FOCUS_ALL)
	pass

func _gui_input(event):
	"""
	if event is InputEventKey:
		print("got key event")
		addInput(OS.get_scancode_string(event.scancode))
		addInput(PoolByteArray([event.unicode]).get_string_from_utf8())
		accept_event()
	"""
	
	"""
	if (event is InputEventKey):
		if(OS.get_scancode_string(event.scancode).length() == 1):
			
			print("got event")
			
			if(event.shift):
				print(OS.get_scancode_string(event.scancode))
			else:
				print(OS.get_scancode_string(event.scancode).to_lower())
			accept_event()
	"""
	if event is InputEventKey && event.is_pressed():
		if event.scancode == KEY_ENTER:
			applyInput()
		elif event.scancode == KEY_BACKSPACE:
			if !currentLine.empty():
				currentLine = currentLine.substr(0, currentLine.length() - 1)
				updateLabel()
		else:
			addInput(PoolByteArray([event.unicode]).get_string_from_utf8())
		accept_event()

func addInput(text):
	currentLine += text
	updateLabel()

func addOutput(text):
	history += text
	updateLabel()

func applyInput():
	history += currentLine + '\n'
	currentLine = ""
	updateLabel()

func updateLabel():
	$label.set_bbcode(history + currentLine)
