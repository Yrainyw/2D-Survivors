extends CanvasLayer

signal transitioned_halfway

var skip_emit = false
var is_transitioning = false


func transition():
	if is_transitioning:
		return
	is_transitioning = true

	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished

	transitioned_halfway.emit()
	skip_emit = true

	$AnimationPlayer.play_backwards("default")
	await $AnimationPlayer.animation_finished

	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	is_transitioning = false


func emit_transitioned_halfway():
	if skip_emit:
		skip_emit = false
		return

	transitioned_halfway.emit()
