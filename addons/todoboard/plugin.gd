@tool
extends EditorPlugin

const TODOS_DOCK_SCENE = preload("res://addons/todoboard/todo_dock/todos_dock.tscn")
const TODO_BOARD_SCENE = preload("res://addons/todoboard/board/td_board.tscn")
const TODO_ITEM = preload("res://addons/todoboard/scripts/todo_item.gd")

var todos_dock_instance: ToDosDock
var todo_board_instance: TDBoard

var todos: Dictionary[String, Array] = {}


func _enter_tree() -> void:
	todo_board_instance = TODO_BOARD_SCENE.instantiate()
	EditorInterface.get_editor_main_screen().add_child(todo_board_instance)
	_make_visible(false)
	
	todos_dock_instance = TODOS_DOCK_SCENE.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR , todos_dock_instance)
	
	EditorInterface.get_resource_filesystem().connect("filesystem_changed", _on_file_system_changed)
	
	_scan_directory()
	todos_dock_instance.build_tree(todos)


func _exit_tree() -> void:
	if todo_board_instance:
		todo_board_instance.queue_free()
	
	remove_control_from_docks(todos_dock_instance)
	todos_dock_instance.free()


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if todo_board_instance:
		todo_board_instance.visible = visible


func _get_plugin_name() -> String:
	return "TD Board"


func _get_plugin_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon("Window", "EditorIcons")


func _scan_directory(path: String = "res://") -> void:
	var dir := DirAccess.open(path)
	
	if dir != null:
		dir.include_hidden = false
		dir.include_navigational = false
		dir.list_dir_begin()
		var dir_item := dir.get_next()
		
		while dir_item != "":
			var item_path = path
			if path == "res://":
				item_path += dir_item
			else:
				item_path += "/" + dir_item
				
			if dir.current_is_dir():
				if not dir_item in ["addons", ".godot"]:
					_scan_directory(dir_item)
			else:
				if dir_item.get_extension() == "gd" || dir_item.get_extension() == "cs":
					_scan_file(path, dir_item)
			
			dir_item = dir.get_next()
			
		dir.list_dir_end()
	else:
		printerr("TODOBOARD Error accessing " + path)


func _scan_file(path: String, file_name: String) -> void:
	var file_path = path
	if path == "res://":
		file_path += file_name
	else: 
		file_path += "/" + file_name
	
	var file := FileAccess.open(file_path, FileAccess.READ)
	var contents := file.get_as_text()
	var regex := _build_regex()
	var results := regex.search_all(contents)

	for result in results:
		var todo_item := TODO_ITEM.new()
		var result_tag := result.get_string(1)
		
		var line_number := 0

		for line in contents.split("\n"):
			if line.strip_edges(true) == result.get_string(0):
				break
			else:
				line_number += 1
				
		todo_item.description = result.get_string(3)
		todo_item.script_path = file_path
		todo_item.type = ToDoItem.get_type(result_tag)
		todo_item.line = line_number
		
		if todos.has(file_path):
			todos[file_path].append(todo_item)
		else:
			todos[file_path] = [todo_item]


func _build_regex() -> RegEx:
	var regex = RegEx.new()
	var combined_tags := ""
	
	for type in ToDoItem.Type.values():
		combined_tags += ToDoItem.TYPE_TAG[type] + "|"
	combined_tags = combined_tags.trim_suffix("|")
	
	var regex_query = "(?:#|//)\\s*(%s)\\s*(\\:)?\\s*([^\\n]+)" % combined_tags
	regex.compile(regex_query)
	
	assert(regex.is_valid())

	return regex


func _on_file_system_changed() -> void:
	todos = {}
	_scan_directory()
	todos_dock_instance.build_tree(todos)
	printt("TODOS: ", todos)
