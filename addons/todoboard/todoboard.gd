@tool
extends EditorPlugin

const TODOS_DOCK_SCENE = preload("res://addons/todoboard/todo_dock/todos_dock.tscn")
const TODO_BOARD_SCENE = preload("res://addons/todoboard/board/td_board.tscn")

var todos_dock_instance: ToDosDock
var todo_board_instance: TDBoard

var scan_running := false

func _enter_tree() -> void:
	todo_board_instance = TODO_BOARD_SCENE.instantiate()
	EditorInterface.get_editor_main_screen().add_child(todo_board_instance)
	_make_visible(false)
	
	todos_dock_instance = TODOS_DOCK_SCENE.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR , todos_dock_instance)
	
	EditorInterface.get_resource_filesystem().connect("filesystem_changed", _on_file_system_changed)


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


func _scan_files() -> void:
	#Store todos in dic rather than repopulate on every change
	#can force a cache purge here
	scan_running = true
	var scripts := _get_all_scripts()
	
	pass


func _get_all_scripts() -> Array[String]:
	var scripts: Array[String] = []
	var root := DirAccess.open("res://")
	
	if root.get_open_error() == 0:
		pass
	else:
		printerr("TODOBOARD Error accessing root directory")
	
	return scripts
	

func _on_file_system_changed() -> void:
	if scan_running: return
	_scan_files()
