@tool
extends Control
class_name ToDosDock

const EXTERNAL_LINK = preload("res://addons/assets/icons/external_link.png")

@onready var tree: Tree = $Tree

func build_tree(todos: Dictionary) -> void:
	tree.clear()
	var root := tree.create_item()
	tree.set_hide_root(true)
	tree.set_columns(2)
	tree.set_column_expand(0, true)
	tree.set_column_expand(1, false)
	tree.set_column_custom_minimum_width(0, 100)
	tree.set_column_custom_minimum_width(1, 24)

	for file: String in todos:
		var file_tree_item := tree.create_item(root)
		file_tree_item.set_text(0, file)

		for todo in todos[file]:
			var todo_item := tree.create_item(file_tree_item)
			todo_item.set_text(0, str(todo["type"]) + ": " + todo["description"])
			todo_item.add_button(1, EXTERNAL_LINK, -1, false, "Jump to source")
			todo_item.set_custom_color(0, Color.GREEN)
