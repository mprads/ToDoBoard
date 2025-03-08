@tool
extends Panel

const CARD = preload("res://addons/todoboard/card/card.tscn")

@onready var header_color: ColorRect = %HeaderColor
@onready var task_count: Label = %TaskCount
@onready var panel_tag: Label = %PanelTag
@onready var task_container: VBoxContainer = %TaskContainer

var panel_type: int
var todos: Dictionary[String, Array] = {} : set = _set_todos 
var panel_todos: Array[ToDoItem] = []


func _ready() -> void:
	panel_tag.text = ToDoItem.get_tag(panel_type)
	header_color.color = Color(ToDoItem.get_color(panel_type))


func _create_cards() -> void:
	if not is_node_ready():
		await ready
	
	for child in task_container.get_children():
		child.queue_free()
	
	for todo: ToDoItem in panel_todos:
		var card_instance = CARD.instantiate()
		card_instance.todo_item = todo
		task_container.add_child(card_instance)
	

func _set_todos(new_todos: Dictionary[String, Array]) -> void:
	if not is_node_ready():
		await ready

	var filtered_todos: Array[ToDoItem] = []
		
	for path in new_todos:
		for todo: ToDoItem in new_todos[path]:
			if todo.type == panel_type:
				filtered_todos.append(todo)
	
	panel_todos = filtered_todos
	
	if panel_todos.size():
		_create_cards()
		task_count.text = str(panel_todos.size())
