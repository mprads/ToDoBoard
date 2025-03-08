@tool
extends Control

@onready var path_label: Label = %PathLabel
@onready var body: Label = %Body

var todo_item: ToDoItem

func _ready() -> void:
	if not is_node_ready():
		await ready

	path_label.text = todo_item.script_path
	body.text = todo_item.description
