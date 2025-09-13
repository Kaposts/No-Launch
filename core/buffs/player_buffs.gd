## This file will hold all the data that from buff cards
extends Node2D

@onready var buff = preload("res://core/buffs/buff.gd")

func get_buffs() -> PlayerBuffsResource:
	var bonus_army: int = 0
	var bonus_damage: int = 0
	var bonus_health: int = 0
	var bonus_speed: int = 0

	var buffs: Array = get_children()
	
	for buff: Buff in buffs:
		var data = buff.data
		if data is ArmyBuffResource:
			bonus_damage += buff.data.damage
			bonus_health += buff.data.health
			bonus_speed += buff.data.speed

		if data is ArmySizeResource:
			bonus_army += buff.army_amount

	var resource = PlayerBuffsResource.new()
	resource.bonus_army = bonus_army
	resource.bonus_damage = bonus_damage
	resource.bonus_health = bonus_health
	resource.bonus_speed = bonus_speed

	return resource

func assign_card(activation: ActivationResource):
	var buff_instance: Buff = preload("res://core/buffs/buff.gd").new()
	buff_instance.data = activation
	add_child(buff_instance)

	var sprites:Array = []
	#buff animation logic
	print('assign)')
	if activation is ArmyBuffResource:
		print('yes)')
		if activation.damage > 0:
			sprites.append(load("res://entities/assets/buffs/buff1.png"))
		if activation.health > 0:
			sprites.append(load("res://entities/assets/buffs/buff2.png"))
		if activation.speed > 0:
			sprites.append(load("res://entities/assets/buffs/buff3.png"))

	SignalBus.buff_applied.emit(sprites)
