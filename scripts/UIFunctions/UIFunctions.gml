// Global game settings
global.gmui_volume = 50;
global.gmui_resolution_w = window_get_width();
global.gmui_resolution_h = window_get_height();
global.gmui_fullscreen = window_get_fullscreen();
global.gmui_aa = gpu_get_texfilter();
global.gmui_shadows = false;

// Available resolution options
global.gmui_resolutions = [ [1366,768], [1920,1080], [2560,1440], [3840,2160] ];

// UI text localisation mapping
global.gmui_text = {};

// Game pause state
global.gmui_paused = false;

// References to UI control instances in the Options menu
global.gmui_control_volume = undefined;
global.gmui_control_resolution = undefined;
global.gmui_control_fullscreen = undefined;
global.gmui_control_aa = undefined;
global.gmui_control_language = undefined;

#export ApplyOptions, CancelConfirmation, CancelOptions, OpenEquipment, OpenOptions, CloseEquipment, Confirm, ConfirmQuit, ExitGame, Pause, Quit

/// @desc Constructor for storing an instance ID and its associated localisation string
/// @param {Id.Instance} _inst The instance ID
/// @param {String} _string The localisation string key
function AddLocalisedText(_inst,_string) constructor {
    instance = _inst;
    localisation_string = _string;
}

/// @desc Finds the instance ID for a given object type within a FlexPanel struct
/// @param {Struct} _struct FlexPanel struct containing layer elements
/// @param {Asset.GMObject} _object_id The object index to search for
/// @returns {Id.Instance} The instance ID if found, undefined otherwise
function GetInstanceIDFromElement(_struct,_object_id){
	for(var _e=0; _e<array_length(_struct.layerElements); _e++){
		if(struct_exists(_struct.layerElements[_e], "instanceObjectIndex")){
			if(_struct.layerElements[_e].instanceObjectIndex == _object_id){
				return _struct.layerElements[_e].instanceId;
			}
		}
	}
	return undefined;
}

/// @desc Finds the layerElement id for the first text instance in the supplied struct
/// @param {any*} _struct Flexpanel struct, use flexpanel_node_get_struct()
/// @returns {real} ID of layerElement
function GetTextElementId(_struct){
    if(!is_struct(_struct)){
        _struct = flexpanel_node_get_struct(_struct);
    }
	for(var _e=0; _e<array_length(_struct.layerElements); _e++){
		if(struct_exists(_struct.layerElements[_e], "type")){
			if(_struct.layerElements[_e].type == "Text"){
				return _struct.layerElements[_e].elementId;
			}
		}
	}
	return undefined;
}

/// @desc Locates and stores references to all control instances in the Options menu
function FindControls(){
    // Get a handle to the layer
	var _layer = layer_get_flexpanel_node("GMUI_Options");
	var _controls = flexpanel_node_get_child(_layer, "Inner");

	var _volume_fp = flexpanel_node_get_child(flexpanel_node_get_child(_controls,"Volume"),"Control");
	global.gmui_control_volume = GetInstanceIDFromElement(flexpanel_node_get_struct(_volume_fp),Slider);
    var _resolution_fp = flexpanel_node_get_child(flexpanel_node_get_child(_controls,"Resolution"),"Control");
	global.gmui_control_resolution = GetInstanceIDFromElement(flexpanel_node_get_struct(_resolution_fp),DropDown);
    var _fullscreen_fp = flexpanel_node_get_child(flexpanel_node_get_child(_controls,"Fullscreen"),"Control");
	global.gmui_control_fullscreen = GetInstanceIDFromElement(flexpanel_node_get_struct(_fullscreen_fp),CheckBox);
    var _aa_fp = flexpanel_node_get_child(flexpanel_node_get_child(_controls,"AA"),"Control");
	global.gmui_control_aa = GetInstanceIDFromElement(flexpanel_node_get_struct(_aa_fp),CheckBox);
    var _language_fp = flexpanel_node_get_child(flexpanel_node_get_child(_controls,"Language"),"Control");
	global.gmui_control_language = GetInstanceIDFromElement(flexpanel_node_get_struct(_language_fp),DropDown);
}

/// @desc Populate all the various available options
function FillOptions(){
	// Get current volume
	if(!is_undefined(global.gmui_control_volume)){
		global.gmui_control_volume.current_value = global.gmui_volume;
	}
	// Get current resolution
    var _selected = undefined;
	if(!is_undefined(global.gmui_control_resolution)){
        var _list = array_create(0,0);
        for(var _l=0; _l < array_length(global.gmui_resolutions); _l++){
            _list[_l] = $"{global.gmui_resolutions[_l][0]} x {global.gmui_resolutions[_l][1]}";
            if((global.gmui_resolutions[_l][0] == global.gmui_resolution_w) && (global.gmui_resolutions[_l][1] == global.gmui_resolution_h)){
                _selected = _l;
            }
        }
		global.gmui_control_resolution.FillList(_list);
        global.gmui_control_resolution.selected = _selected;
	}
	
	// Get current fullscreen state
	if(!is_undefined(global.gmui_control_fullscreen)){
		global.gmui_control_fullscreen.checked = global.gmui_fullscreen;
	}
	
	// Get current AA state
	if(!is_undefined(global.gmui_control_aa)){
		global.gmui_control_aa.checked = global.gmui_aa;
	}
	
	// Get current language
    _selected = undefined;
	if(!is_undefined(global.gmui_control_language)){
        var _list = array_create(0,0);
        for(var _l=0; _l < array_length(global.gmui_languages); _l++){
            _list[_l] = $"{global.gmui_languages[_l]}";
            if(global.gmui_language == _list[_l]){
                _selected = _l;
            }
        }
		global.gmui_control_language.FillList(_list);
        global.gmui_control_language.selected = _selected;
	}
	
	
}


/// @desc Close the options menu and appy changes
function ApplyOptions(){
	// Set Volume
    if(!is_undefined(global.gmui_control_volume)){
	   global.gmui_volume = global.gmui_control_volume.current_value;
    }
    
	// Set Resolution
	if(!is_undefined(global.gmui_control_resolution)){
		// If the os_type is not a mobile device
		if (os_type != os_android && os_type != os_ios){
			window_set_size(global.gmui_resolutions[global.gmui_control_resolution.selected][0],global.gmui_resolutions[global.gmui_control_resolution.selected][1]);
		}
		
		global.gmui_resolution_w = window_get_width();
        global.gmui_resolution_h = window_get_height();
        window_center();
        if((window_get_x() < 0) || (window_get_y() < 0)){
            application_get_position()
            window_set_position(1,1);
        }
    }
    
	// Set Fullscreen
	if(!is_undefined(global.gmui_control_fullscreen)){
        global.gmui_fullscreen = global.gmui_control_fullscreen.checked;
		window_set_fullscreen(global.gmui_fullscreen);
	}
    
	// Set AA
	if(!is_undefined(global.gmui_control_aa)){
        global.gmui_aa = global.gmui_control_aa.checked;
		gpu_set_tex_filter(global.gmui_aa);
	}
    
	// Set Language
	if(!is_undefined(global.gmui_control_language)){
        global.gmui_language = global.gmui_languages[global.gmui_control_language.selected];
		Localisation_Update_All();
    }
	
	
	// Close options
	layer_set_visible("GMUI_Options",false);
}


/// @desc Close the options menu without saving changes
function CancelOptions(){
	layer_set_visible("GMUI_Options",false);
	layer_set_visible("GMUI_MainMenu",true);
}

/// @desc Open the options menu
function OpenOptions(){
	if(layer_exists("GMUI_Options")){
		HideAllUI();
	    layer_set_visible("GMUI_Options",true);
		FindControls();
		GetAllText();
		FillOptions();
	}
}

/// @desc Close the equipment/character screen
function CloseEquipment(){
    layer_set_visible("GMUI_Character",false);
}

/// @desc Open the equipment/character screen
function OpenEquipment(){
    layer_set_visible("GMUI_Character",true);
}

/// @desc Opens the confirmation message box 
/// @param {function} _yes The function to call if the user selects Yes
/// @param {function} _no The function to call if the user selects No - Defaults to closing the box without doing anything
function Confirm(_yes, _no=CancelConfirmation){
	if(layer_exists("GMUI_Confirmation")){
		layer_set_visible("GMUI_Confirmation",true);
		var _layer = layer_get_flexpanel_node("GMUI_Confirmation");
		var _yes_button = GetInstanceIDFromElement(flexpanel_node_get_struct(flexpanel_node_get_child(_layer,"Yes")),Button);
		var _no_button = GetInstanceIDFromElement(flexpanel_node_get_struct(flexpanel_node_get_child(_layer,"No")),Button);
		_yes_button.button_release = _yes;
		_no_button.button_release = _no;
	} else {
		// if the confirmation layer doesnt exist then skip the confirmation and call the _yes function
		method_call(_yes);
	}
}

/// @desc Close the confirmation box without doing anything
function CancelConfirmation(){
	layer_set_visible("GMUI_Confirmation",false);
}

/// @desc Close the game
function ExitGame(){
	Confirm(game_end);
}

/// @desc Pause/unpause the game
function Pause(){
	global.gmui_previous_menu = "GMUI_Pause";
	global.gmui_paused = !global.gmui_paused;
	HideAllUI();
	layer_set_visible("GMUI_Pause",global.gmui_paused);
	if(global.gmui_paused){
		// pause all your game logic from here
	} else {
		// unpause all your game logic here
	}
}

/// @desc Open a confirmation dialog before quitting to the main menu
function ConfirmQuit(){
	Confirm(Quit);
}

/// @desc Quit the current game and return to the main menu
function Quit(){
	HideAllUI();
	layer_set_visible("GMUI_MainMenu",true);
	global.gmui_paused = false;
}

/// @desc Hide all the UI Layers
function HideAllUI(){
	layer_set_visible("GMUI_MainMenu",false);
	layer_set_visible("GMUI_Confirmation",false);
	layer_set_visible("GMUI_Options",false);
	layer_set_visible("GMUI_Character",false);
	layer_set_visible("GMUI_GameOver",false);
	layer_set_visible("GMUI_Pause",false);
}