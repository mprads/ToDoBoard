@tool
extends Control
class_name ToDosDock

@onready var tree: Tree = $Tree

func setup() -> void:
	_build_tree()

func _build_tree() -> void:
	tree.clear()
	tree.set_hide_root(true)
	tree.set_columns(3)
	tree.set_column_expand(0, true)
	tree.set_column_expand(1, false)
	tree.set_column_expand(2, false)
	tree.set_column_custom_minimum_width(0, 100)
	tree.set_column_custom_minimum_width(1, 24)
	tree.set_column_custom_minimum_width(2, 24)
