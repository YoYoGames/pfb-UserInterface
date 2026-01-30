if(keyboard_check(vk_control) && keyboard_check_released(ord("E"))){
    if(layer_get_visible("GMUI_Character")){
        CloseEquipment();
    } else {
        OpenEquipment();
    }
}

if(keyboard_check_released(vk_escape)){
	if(!global.paused){
		Pause();
	}
}