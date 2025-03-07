@tool
extends Control
class_name TDBoard

const TAG_PANEL = preload("res://addons/todoboard/tag_panel/tag_panel.tscn")
const CARD = preload("res://addons/todoboard/card/card.tscn")


func _ready() -> void:
	for tag in ToDoItem.TYPE_TAG.size():
		print(tag)
		var panel_instance = TAG_PANEL.instantiate()
		add_child(panel_instance)
