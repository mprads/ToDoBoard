@tool
extends Control
class_name ToDosDock

const EXTERNAL_LINK = preload("res://addons/assets/icons/external_link.png")
const FILE = preload("res://addons/assets/icons/file.png")

@onready var tree: Tree = $Tree


func _ready() -> void:
	tree.button_clicked.connect(_on_button_clicked)


func build_tree(todos: Dictionary) -> void:
	tree.clear()
	var root := tree.create_item()
	tree.hide_root = true
	tree.set_columns(1)
	tree.set_column_expand(0, true)

	for file: String in todos:
		var file_tree_item := tree.create_item(root)
		file_tree_item.set_text(0, file)
		file_tree_item.add_button(0, FILE, -1, false, "Open File")
		file_tree_item.set_metadata(0, { "path": file, "line": 0 })

		for todo in todos[file]:
			var todo_item := tree.create_item(file_tree_item)
			todo_item.set_text(0, str(ToDoItem.TYPE_TAG[todo.type]) + ": " + todo.description)
			todo_item.set_custom_color(0, ToDoItem.TYPE_COLOR[todo.type])
			todo_item.add_button(0, EXTERNAL_LINK, -1, false, "Jump to Line")
			todo_item.set_metadata(0, { "path": file, "line": todo.line })


func _on_button_clicked(item: TreeItem, column: int, id: int, index: int) -> void:
	var editor := EditorInterface.get_script_editor()
	var base_editor := editor.get_current_editor()
	base_editor.emit_signal("request_open_script_at_line", load(item.get_metadata(0)["path"]), item.get_metadata(0)["line"])
