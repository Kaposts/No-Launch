extends Node
## Global SFX Player Script

@onready var card_played_sfx_player: RandomAudioPlayer = $CardPlayedSFXPlayer
@onready var discard_sfx_player: RandomAudioPlayer = $DiscardSFXPlayer
@onready var debuffed_sfx_player: RandomAudioPlayer = $DebuffedSFXPlayer
@onready var major_glitch_sfx_player: RandomAudioPlayer = $MajorGlitchSFXPlayer
@onready var minor_glitch_sfx_player: RandomAudioPlayer = $MinorGlitchSFXPlayer
@onready var energy_increased_sfx_player: RandomAudioPlayer = $EnergyIncreasedSFXPlayer
