/// @description Handle keyboard shortcuts for equipment menu (Ctrl+E) and pause menu (Escape)

// Toggle equipment/character screen with Ctrl+E
if(keyboard_check(vk_control) && keyboard_check_released(ord("E"))){
	if (layer_exists("GMUI_Character")){
		if(layer_get_visible("GMUI_Character")){
        	CloseEquipment();
    	} else {
    	    OpenEquipment();
    	}
	}
}

// Open pause menu with Escape (only if not already paused)
if(keyboard_check_released(vk_escape)){
	if(!global.gmui_paused){
		Pause();
	}
}