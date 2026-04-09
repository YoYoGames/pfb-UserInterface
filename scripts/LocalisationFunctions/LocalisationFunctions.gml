global.gmui_language = "English";
global.gmui_languages = array_create(0,0);
global.gmui_language_strings = {};
global.gmui_language_loaded = false;
global.gmui_language_file = "localisation.csv"

#export GetLocalisation, Localisation_Update_All, SetLocalisationFile

/// @desc Use to change the file that will be used for localisation lookups
/// @param {String} _filename The filename of the csv to use for localisation strings
function SetLocalisationFile(_filename){
	global.gmui_language_file = _filename;
}

function GetLocalisation(_string_name,_language=global.gmui_language){
	// make sure that the language strings have been loaded
	if(!global.gmui_language_loaded){
		Localisation_Load(global.gmui_language_file);
	}
    var _lang = variable_struct_get(global.gmui_language_strings,_language)
    var _string = variable_struct_get(_lang,_string_name);
    return _string;
}

function SetLocalisationFromStruct(_name,_value){
    layer_text_text(_value.instance,GetLocalisation(_value.localisation_string));
}

function Localisation_Update_All(){
	// enable all ui layers so deactivated objects are localised
	SetVisibilityAllUI(true);
	
	// change all the parented objects
    with(oLocalised){ 
		// If localisation_string is set
		if (!is_undefined(localisation_string) && string_length(localisation_string) > 0)
		{
			// Set text to be the localised string or show 'string not found' if there was not a matching entry
			var _localisedString = GetLocalisation(localisation_string);
			text = (!is_undefined(_localisedString)) ? _localisedString : "string not found";
		}
    }
    
	// change all the text elements
	struct_foreach(global.gmui_text, SetLocalisationFromStruct);
	
	// recalculate layouts incase changing the localisations would change things
	if (layer_exists("GMUI_Confirmation")){
		flexpanel_calculate_layout(layer_get_flexpanel_node("GMUI_Confirmation"), , , flexpanel_direction.LTR);
	}
	if (layer_exists("GMUI_Pause")){
		flexpanel_calculate_layout(layer_get_flexpanel_node("GMUI_Pause"), , , flexpanel_direction.LTR);
	}
	if (layer_exists("GMUI_Options")){
		flexpanel_calculate_layout(layer_get_flexpanel_node("GMUI_Options"), , , flexpanel_direction.LTR);
	}
	if (layer_exists("GMUI_Character")){
		flexpanel_calculate_layout(layer_get_flexpanel_node("GMUI_Character"), , , flexpanel_direction.LTR);
	}
	if (layer_exists("GMUI_GameOver")){
		flexpanel_calculate_layout(layer_get_flexpanel_node("GMUI_GameOver"), , , flexpanel_direction.LTR);
	}
	
	// disable all the layers again
	SetVisibilityAllUI(false)
	
	// enable the Main Menu
	SetVisibilitySingleUI("GMUI_MainMenu", true)
}


function Localisation_Load(_filename){
    var _file = load_csv(_filename);
    var _width = ds_grid_width(_file);
    var _height = ds_grid_height(_file);
	
	// check to see if there are already any strings loaded, if there are then we will need to clear them out 
	if(array_length(global.gmui_languages) > 0){
		array_resize(global.gmui_languages,0);
		global.gmui_language_strings = {};
	}

    // convert all the languages into a struct of structs
    for(var _l=1; _l<_width; _l++){
        var _name = _file[# _l, 1];
        array_push(global.gmui_languages,_name); 
        variable_struct_set(global.gmui_language_strings,_name,{});
        for(var _s=0; _s<_height; _s++){
            variable_struct_set(variable_struct_get(global.gmui_language_strings,_name),_file[# 0, _s], _file[#_l, _s]);
        }
    }
	global.gmui_language_loaded = true;
}

function GetAllText(){
	// Initialise all of the layer values
	var _layer_confirm, _layer_pause, _layer_options, _layer_character, _layer_gameover, _layer_mainmenu = false;
	
	// get all UI layers
	if (layer_exists("GMUI_Confirmation")){
		_layer_confirm = layer_get_flexpanel_node("GMUI_Confirmation");
	}
	if (layer_exists("GMUI_Pause")){
		_layer_pause = layer_get_flexpanel_node("GMUI_Pause");
	}
	if (layer_exists("GMUI_Options")){
		_layer_options = layer_get_flexpanel_node("GMUI_Options");
	}
	if (layer_exists("GMUI_Character")){
		_layer_character = layer_get_flexpanel_node("GMUI_Character");
	}
	if (layer_exists("GMUI_GameOver")){
		_layer_gameover = layer_get_flexpanel_node("GMUI_GameOver");
	}
	if (layer_exists("GMUI_MainMenu")){
		_layer_mainmenu = layer_get_flexpanel_node("GMUI_MainMenu");
	}
	
	// titles
	if (_layer_confirm){
		global.gmui_text.title_confirmation = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(_layer_confirm,"TitleText")),"title_confirmation");
	}
	if (_layer_pause){
		global.gmui_text.title_paused = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(_layer_pause,"TitleText")),"title_paused");
	}
	if (_layer_options){
		global.gmui_text.title_options = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(_layer_options,"TitleText")),"title_options");
	}
	if (_layer_character){
		global.gmui_text.title_equipment = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(_layer_character,"TitleText")),"title_equipment");
	}
	if (_layer_gameover){
		global.gmui_text.title_gameover = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(_layer_gameover,"TitleText")),"title_gameover");
	}

	// confirm
	if (_layer_confirm){
		global.gmui_text.text_sure = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(flexpanel_node_get_child(_layer_confirm,"TextBox"),"Text")),"text_sure");	
	}
	
	// options
	if (_layer_options){
		global.gmui_text.options_volume = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(flexpanel_node_get_child(_layer_options,"Volume"),"Text")),"setting_volume");
		global.gmui_text.options_resolution = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(flexpanel_node_get_child(_layer_options,"Resolution"),"Text")),"setting_resolution");
		global.gmui_text.options_fullscreen = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(flexpanel_node_get_child(_layer_options,"Fullscreen"),"Text")),"setting_fullscreen");
		global.gmui_text.options_aa = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(flexpanel_node_get_child(_layer_options,"AA"),"Text")),"setting_antialiasing");
		global.gmui_text.options_language = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(flexpanel_node_get_child(_layer_options,"Language"),"Text")),"setting_language");
	}
	
	// character
	if (_layer_character){
		global.gmui_text.character_health = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(flexpanel_node_get_child(_layer_character,"Health"),"Text")),"character_health");	
		global.gmui_text.character_armour = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(flexpanel_node_get_child(_layer_character,"Armour"),"Text")),"character_armour");	
		global.gmui_text.character_attack = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(flexpanel_node_get_child(_layer_character,"Attack"),"Text")),"character_attack");	
		global.gmui_text.character_movement = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(flexpanel_node_get_child(_layer_character,"Movement"),"Text")),"character_movement");	
		global.gmui_text.character_luck = new AddLocalisedText(GetTextElementId(flexpanel_node_get_child(flexpanel_node_get_child(_layer_character,"Luck"),"Text")),"character_luck");	
	}
}