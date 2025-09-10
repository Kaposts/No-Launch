@tool
extends EditorPlugin

var lines: Array[String] = []

var sounds: Array[SFXData] = []
var library: SFXLibrary = SFXLibrary.new()

var output_directory: String = "res://addons/sfx_generator/"
var output_file_name: String = "Sound"

var button: Button

var config: SFXGeneratorConfig = preload("res://addons/sfx_generator/config/config.tres")

func _enter_tree():
    ## Create a button in the toolbar
    button = Button.new()
    button.text = "Generate Sounds"
    button.tooltip_text = "Scan SFX folder and generate Sounds.gd"
    button.pressed.connect(_on_button_pressed)
    add_control_to_container(CONTAINER_TOOLBAR, button)
    button.show()
    print("SFX Generator plugin loaded")

func _exit_tree():
    # Remove button when plugin is disabled
    remove_control_from_container(CONTAINER_TOOLBAR, button)
    button.free()


## TODO I want to also make this read folders as prefixes for the sfx for example:
## sfx with path(player/hit.ogg) would save it's const as PLAYER_HIT
## and maybe store all consts with prefix sfx_ so that it is easier to filter out consts 

func _on_button_pressed():
    assert(config,"Config not found")
    assert(config.sfx_directory != "","sfx_directory can't be empty")
    assert(config.output_directory != "","output_directory can't be empty")
    assert(config.output_file_name != "","output_file_name can't be empty")

    ## Set up directories from config
    output_directory = config.output_directory
    output_file_name = config.output_file_name
    
    ## TODO could make this to copy a file 
    lines = ["## Made using sfx_generator\n","## This is a auto generated file to store sound consts\n","extends Node\n","class_name ", output_file_name.to_pascal_case(),"\n", ]
    read_sfx_files()
    generate_library()
    write_const_file()

func create_sfx_data(sfx: AudioStream) -> SFXData:
    var sfx_name = get_base_name(sfx)
    var const_name = sfx_name.to_upper().replace(" ", "_").replace("-", "_")

    var data = SFXData.new()
    data.res_name = sfx_name
    data.res_stream = sfx

    lines.append("const %s = \"%s\"\n" % [const_name, sfx_name.to_lower()])
    library.sounds.append(data)

    return data

func write_const_file():
    var file = FileAccess.open(output_directory + output_file_name + ".gd", FileAccess.WRITE)
    if file:
        var str = ""
        file.store_string(str.join(lines))
        file.close()
        print("Sounds.gd generated!")

    else:
        print("Failed to write file: ", output_file_name + ".gd")

func read_sfx_files():
    var path = config.sfx_directory
    print("Scanning: ", path)

    var dir = DirAccess.open(path)
    if dir == null:
        push_error("Cannot open folder: %s" % path)
        return

    _scan_dir_recursive(dir, "", path)

func generate_library():
    var save_path = output_directory + "SFXLibrary.tres"
    ResourceSaver.save(library, save_path)

func get_base_name(resource) -> String:
    return resource.resource_path.get_file().get_basename()

func _scan_dir_recursive(dir: DirAccess, prefix: String, base_path: String):
    dir.list_dir_begin()
    var filename = dir.get_next()

    while filename != "":
        if filename.begins_with("."): # skip hidden files
            filename = dir.get_next()
            continue

        var full_path = dir.get_current_dir().path_join(filename)

        if dir.current_is_dir():
            # Recurse into subfolder, add folder name as prefix
            var new_prefix = prefix
            if new_prefix != "":
                new_prefix += "_"
            new_prefix += filename.to_upper()
            var subdir = DirAccess.open(full_path)
            if subdir:
                _scan_dir_recursive(subdir, new_prefix, base_path)
        else:
            if filename.get_extension().to_lower() in ["wav", "ogg"]:
                var stream = load(full_path)

                # Base name of file
                var base_name = filename.get_basename().to_upper()

                # Build const name with prefix and SFX_
                var const_name = "SFX_"
                if prefix != "":
                    const_name += prefix + "_"
                const_name += base_name

                # Normalize name (remove spaces/dashes)
                const_name = const_name.replace(" ", "_").replace("-", "_")

                # Create SFXData
                var data = SFXData.new()
                data.res_name = base_name.to_lower()
                data.res_stream = stream

                lines.append("const %s = \"%s\"\n" % [const_name, data.res_name])
                library.sounds.append(data)

        filename = dir.get_next()

    dir.list_dir_end()
