extends Node2D


var snow_man_scene := preload("res://Scenes/snow_man.tscn")
var box_scene := preload("res://Scenes/box.tscn")
var crystal_scene := preload("res://Scenes/crystal.tscn")
var igloo_scene := preload("res://Scenes/igloo.tscn")
var rock_scene := preload("res://Scenes/rock.tscn")
var sign_scene := preload("res://Scenes/sign.tscn")
var tree_scene := preload("res://Scenes/tree.tscn")



func select_object():
	var objects_scene = [
		snow_man_scene,
		box_scene,
		crystal_scene,
		igloo_scene,
		rock_scene,
		sign_scene,
		tree_scene
	]

	var num_object = randi_range(0,objects_scene.size() - 1)
	var scene_selected = objects_scene[num_object]
	return scene_selected

func select_position_object():
	var numms_selected = []
	while numms_selected.size() < get_child_count():
			var num_position = randi_range(1,get_child_count())
			if not num_position in numms_selected:
				numms_selected.append(num_position)
	return numms_selected



func instance_scenes():
	
	var position_object = select_position_object()
	print(position_object.size())
	for i in range(position_object.size()):
		var object = select_object()
		var object_instance_scene = object.instantiate()
		var marker_selection = get_node("Marker" + str(position_object[i]))
		object_instance_scene.position = marker_selection.position
		add_child(object_instance_scene)


func _on_timer_start_game_timeout() -> void:
	instance_scenes()
