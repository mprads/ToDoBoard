extends Node2D
# TODO: test todo

func _ready() -> void:
	var regex = RegEx.new()

	var options = ["\\bTODO\\b", "\\bBUG\\b", "\\bFIXME\\b"]
	var formatted = []
	
	for option in options:
		formatted.append(option.insert(0, "((?i)") + ")")
	
	var pattern_string := "((\\/\\*)|(#|\\/\\/))\\s*("
	
	for i in formatted.size():
		if i == 0:
			pattern_string += formatted[i]
		else:
			pattern_string += "|" + formatted[i]
		
	pattern_string += ")(?(2)[\\s\\S]*?\\*\\/|.*)"
	regex.compile(pattern_string)
	
	var result = regex.search("asdlfkalsjdfasdfasdfalksdfja # FiXMe alkjsdfalksd")
	if result:
		print("wooo")
