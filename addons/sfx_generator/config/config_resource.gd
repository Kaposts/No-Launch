extends Resource
class_name SFXGeneratorConfig

# ## Pointer to listen for all sfx files and store them seperately in a GD script as consts
@export_dir var sfx_directory: String = "res://assets/SFX"
## Name for the output file that will handle sfx consts. This will also be the class_name which can be used to access these consts
@export var output_file_name: String = "Sound"
## Pointer where to save generated Sound.gd which will store all consts for sounds
@export_dir var output_directory: String = "res://addons/sfx_generator/"

# @export_range(-80, 6, 0.1, "Default volume for generated constants")
# var default_volume_db: float = 0.0
