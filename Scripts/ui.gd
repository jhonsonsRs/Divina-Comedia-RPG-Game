extends CanvasLayer

@onready var quest_label: Label = $QuestDisplay/QuestLabel

func update_quest_objective(text: String) -> void:
	if text.is_empty():
		$QuestDisplay.visible = false
	else:
		$QuestDisplay.visible = true
		quest_label.text = text
