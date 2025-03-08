@tool
extends Control
class_name TDBoard

const TAG_PANEL = preload("res://addons/todoboard/tag_panel/tag_panel.tscn")
const CARD = preload("res://addons/todoboard/card/card.tscn")


func build_panels(todos: Dictionary[String, Array]) -> void:
	for child in get_children():
		child.queue_free()
	
	for tag in ToDoItem.get_all_tags():
		var panel_instance = TAG_PANEL.instantiate()
		panel_instance.panel_type = ToDoItem.get_type(tag)
		panel_instance.todos = todos
		add_child(panel_instance)
