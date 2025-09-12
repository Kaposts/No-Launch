extends Resource
class_name CardData

@export var name: String
@export var type: Enum.CARD_TYPE
@export var rarity: Enum.CARD_RARITY
@export var background: Texture
@export var sprite: Texture
@export var energy: int = 1

@export var activations: Array [ActivationResource]

