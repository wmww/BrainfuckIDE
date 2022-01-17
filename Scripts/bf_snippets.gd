extends ScrollContainer

const ItemScene = preload("res://Scenes/snippet_list_item.tscn")

export(NodePath) var root_node

var snippets = [
	["Hello World", "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."],
	["add", "[>>+<<-]>[>+<-]<"],
	["multiply", "[>[>+>+<<-]>>[<<+>>-]<<<-]>[-]<"],
	["divide", ">>>+<<<[->->>>>+<<<<[>]>>[>>>+<[<<<<+>>>>-]<]<<<<]>>>>>>[<<<<<<+>>>>>>-]<[-]<<-<<[-]<"],
	["get number", ">+[>>,----------[--------------------------------------<<<[>>++++++++++<<-]>>[<<+>>-]>[<<<+>>>-]<]<]<-<"],
	["print number", "[>>+>+<<<-]>>>[<<<+>>>-]<<+>[<->[>++++++++++<[->-[>+>>]>[+[-<+>]>+>>]<<<<<]>[-]++++++++[<++++++>-]>[<<+>>-]>[<<+>>-]<<]>]<[->>++++++++[<++++++>-]]<[.[-]<]<"],
]

func _ready():
	addSnippetsToList()

func addSnippetsToList():
	var box = get_node("box")
	for i in snippets:
		var item = ItemScene.instance()
		item.setData(i[0], i[1], self)
		box.add_child(item)

func runCode(code):
	get_node(root_node).addCodeToController(code)
