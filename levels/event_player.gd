extends AnimationPlayer

@export var current_event := 0
@onready var events := self.get_animation_list().size()

func play_event(event_index := current_event) -> void:
	var events_list: Array = get_animation_list()
	if event_index >= events:
		return
	play(events_list[event_index])
	print("playing event %s" % event_index)


func play_current_event() -> void:
	play_event()
	current_event += 1
