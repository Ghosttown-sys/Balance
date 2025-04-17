extends Control
var label: Label

func set_grid(num : int):
	label= %Label
	if num != -1:
		label.text = str(num)
