extends Control

@onready var sfx_slider := $%SoundSlider
@onready var music_slider := $%MusicSlider
@onready var sfx_cb := $%Sound
@onready var music_cb := $%Music
@onready var back := $%Back
@onready var scene_changer: CanvasLayer = $SceneChanger

var options: ConfigFile


func _ready():
	load_options()
	set_options()


func load_options() -> void:
	options = ConfigFile.new()
	var err = options.load("user://options.cfg")

	if err != OK:
		save_default()


func save_default() -> void:
	options = ConfigFile.new()
	options.set_value("options", "sfx_volume", 100)
	options.set_value("options", "music_volume", 100)
	options.set_value("options", "sfx", true)
	options.set_value("options", "music", true)
	options.save("user://options.cfg")


func save_options() -> void:
	back.disabled = true
	options = ConfigFile.new()
	options.set_value("options", "sfx_volume", sfx_slider.value)
	options.set_value("options", "music_volume", music_slider.value)
	options.set_value("options", "sfx", sfx_cb.button_pressed)
	options.set_value("options", "music", music_cb.button_pressed)
	options.save("user://options.cfg")


func set_options() -> void:
	for option in options.get_sections():
		var sfx_vol = options.get_value(option, "sfx_volume")
		var music_vol = options.get_value(option, "music_volume")
		var sfx = options.get_value(option, "sfx")
		var music = options.get_value(option, "music")
		
		sfx_slider.value = sfx_vol
		_on_sound_slider_value_changed(sfx_vol)
		music_slider.value = music_vol
		_on_music_slider_value_changed(music_vol)
		sfx_cb.button_pressed = sfx
		_on_sound_toggled(sfx)
		music_cb.button_pressed = music
		_on_music_toggled(music)


func _on_sound_toggled(button_pressed: bool) -> void:
	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus, button_pressed)


func _on_music_toggled(button_pressed: bool) -> void:
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(bus, button_pressed)


func _on_sound_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value / 100.0))


func _on_music_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value / 100.0))


func _on_back_pressed() -> void:
	save_options()
	scene_changer.transition_to()
