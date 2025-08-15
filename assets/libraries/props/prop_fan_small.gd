extends Node3D


@export var animPlayer: AnimationPlayer


func _ready() -> void:
	animPlayer.play("Fan_Armature|Fan_Idle")
