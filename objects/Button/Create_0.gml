event_inherited();
base_xscale = image_xscale;
base_yscale = image_yscale;
base_icon_scale = icon_scale;
base_font_scale = text_size/font_get_size(font);
font_scale = base_font_scale;
pressed = false;

if(sprite_index == noone){
    if(icon != noone){
        mask_index = icon;
    } else {
        mask_index = sprite_index;
    }
}

onRelease = function(){
    show_debug_message("Released");
}