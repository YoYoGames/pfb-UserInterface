global.volume = 50;
global.resolution_w = window_get_width();
global.resolution_h = window_get_height();
global.fullscreen = window_get_fullscreen();
global.aa = gpu_get_texfilter();
global.shadows = false;

global.resolutions = [ [1366,768], [1920,1080], [2560,1440], [3840,2160] ];

global.ui_text = {};

global.paused = false;

#export ApplyOptions, CancelConfirmation, CancelOptions, OpenEquipment, OpenOptions, CloseEquipment, Confirm, ConfirmQuit, ExitGame, Pause, Quit

function AddLocalisedText(_inst,_string) constructor {
    instance = _inst;
    localisation_string = _string;
}

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

function FindControls(){
    // Get a handle to the layer
	var _layer = layer_get_flexpanel_node("GMUI_Options");
	var _controls = flexpanel_node_get_child(_layer, "Inner");
	
	var _volume_fp = flexpanel_node_get_child(flexpanel_node_get_child(_controls,"Volume"),"Control");
	global.control_volume = GetInstanceIDFromElement(flexpanel_node_get_struct(_volume_fp),Slider);
    var _resolution_fp = flexpanel_node_get_child(flexpanel_node_get_child(_controls,"Resolution"),"Control");
	global.control_resolution = GetInstanceIDFromElement(flexpanel_node_get_struct(_resolution_fp),DropDown);
    var _fullscreen_fp = flexpanel_node_get_child(flexpanel_node_get_child(_controls,"Fullscreen"),"Control");
	global.control_fullscreen = GetInstanceIDFromElement(flexpanel_node_get_struct(_fullscreen_fp),CheckBox);
    var _aa_fp = flexpanel_node_get_child(flexpanel_node_get_child(_controls,"AA"),"Control");
	global.control_aa = GetInstanceIDFromElement(flexpanel_node_get_struct(_aa_fp),CheckBox);
    var _language_fp = flexpanel_node_get_child(flexpanel_node_get_child(_controls,"Language"),"Control");
	global.control_language = GetInstanceIDFromElement(flexpanel_node_get_struct(_language_fp),DropDown);
}

/// @desc Populate all the various available options
function FillOptions(){
	// Get current volume
	if(!is_undefined(global.control_volume)){
		global.control_volume.current_value = global.volume;
	}
	// Get current resolution
    var _selected = undefined;
	if(!is_undefined(global.control_resolution)){
        var _list = array_create(0,0);
        for(var _l=0; _l < array_length(global.resolutions); _l++){
            _list[_l] = $"{global.resolutions[_l][0]} x {global.resolutions[_l][1]}";
            if((global.resolutions[_l][0] == global.resolution_w) && (global.resolutions[_l][1] == global.resolution_h)){
                _selected = _l;
            }
        }
		global.control_resolution.FillList(_list);
        global.control_resolution.selected = _selected;
	}
	
	// Get current fullscreen state
	if(!is_undefined(global.control_fullscreen)){
		global.control_fullscreen.Checked = global.fullscreen;
	}
	
	// Get current AA state
	if(!is_undefined(global.control_aa)){
		global.control_aa.Checked = global.aa;
	}
	
	// Get current language
    _selected = undefined;
	if(!is_undefined(global.control_language)){
        var _list = array_create(0,0);
        for(var _l=0; _l < array_length(global.languages); _l++){
            _list[_l] = $"{global.languages[_l]}";
            if(global.language == _list[_l]){
                _selected = _l;
            }
        }
		global.control_language.FillList(_list);
        global.control_language.selected = _selected;
	}
	
	
}


/// @desc Close the options menu and appy changes
function ApplyOptions(){
	// Set Volume
    if(!is_undefined(global.control_volume)){
	   global.volume = global.control_volume.current_value;
    }
    
	// Set Resolution
	if(!is_undefined(global.control_resolution)){
        window_set_size(global.resolutions[global.control_resolution.selected][0],global.resolutions[global.control_resolution.selected][1]);
        global.resolution_w = window_get_width();
        global.resolution_h = window_get_height();
        window_center();
        if((window_get_x() < 0) || (window_get_y() < 0)){
            application_get_position()
            window_set_position(1,1);
        }
    }
    
	// Set Fullscreen
	if(!is_undefined(global.control_fullscreen)){
        global.fullscreen = global.control_fullscreen.Checked;
		window_set_fullscreen(global.fullscreen);
	}
    
	// Set AA
	if(!is_undefined(global.control_aa)){
        global.aa = global.control_aa.Checked;
		gpu_set_tex_filter(global.aa);
	}
    
	// Set Language
	if(!is_undefined(global.control_language)){
        global.language = global.languages[global.control_language.selected];
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

function CloseEquipment(){
    layer_set_visible("GMUI_Character",false);
}

function OpenEquipment(){
    layer_set_visible("GMUI_Character",true);
}

/// @desc Opens the confirmation message box 
/// @param {function} _yes The function to call if the user selects Yes
/// @param {function} _no The function to call if the user selects No - Defaults to closing the box without doing anything
function Confirm(_yes, _no=CancelConfirmation){
	layer_set_visible("GMUI_Confirmation",true);
	var _layer = layer_get_flexpanel_node("GMUI_Confirmation");
	var _yes_button = GetInstanceIDFromElement(flexpanel_node_get_struct(flexpanel_node_get_child(_layer,"Yes")),Button);
	var _no_button = GetInstanceIDFromElement(flexpanel_node_get_struct(flexpanel_node_get_child(_layer,"No")),Button);
	_yes_button.Button_Release = _yes;
	_no_button.Button_Release = _no;
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
	global.previous_menu = "GMUI_Pause";
	global.paused = !global.paused;
	HideAllUI();
	layer_set_visible("GMUI_Pause",global.paused);
	if(global.paused){
		// pause all your game logic from here
	} else {
		// unpause all your game logic here
	}
}

function ConfirmQuit(){
	Confirm(Quit);
}

/// @desc Quit the current game and return to the main menu
function Quit(){
	HideAllUI();
	layer_set_visible("GMUI_MainMenu",true);
	global.paused = false;
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