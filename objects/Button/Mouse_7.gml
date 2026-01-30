if(prevent_clickthrough){
	exit;
}
if(pressed){
    image_xscale = base_xscale
    image_yscale = base_yscale;
    icon_scale = base_icon_scale;
    font_scale = base_font_scale;
    if(sound != noone){
        audio_play_sound(sound,10,false);
    }
    if(!is_undefined(button_release)){
        method_call(button_release);
    } else {
        method_call(onRelease);
    }
}
