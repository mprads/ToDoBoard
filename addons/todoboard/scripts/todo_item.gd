@tool
extends RefCounted
class_name ToDoItem

enum Type { TODO, BUG, FIXME }

const TYPE_COLOR := {
	ToDoItem.Type.TODO: Color.PALE_GREEN,
	ToDoItem.Type.BUG: Color.SANDY_BROWN,
	ToDoItem.Type.FIXME: Color.INDIAN_RED
}

const TYPE_TAG := {
	ToDoItem.Type.TODO: "TODO",
	ToDoItem.Type.BUG: "BUG",
	ToDoItem.Type.FIXME: "FIXME"
}

var script_path: String
var type: Type
var description: String

static func get_type(tag: String) -> Type:
	var lower_todo := ToDoItem.TYPE_TAG[Type.TODO].to_lower()
	var lower_bug := ToDoItem.TYPE_TAG[Type.BUG].to_lower()
	var lower_fixme := ToDoItem.TYPE_TAG[Type.FIXME].to_lower()
	
	match tag.to_lower():
		lower_todo:
			return Type.TODO
		lower_bug:
			return Type.BUG
		lower_fixme:
			return Type.FIXME
		_:
			return Type.TODO
