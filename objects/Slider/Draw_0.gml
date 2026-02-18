/// @description Draw the slider bar and handle at their current positions

// Update the position of the slider
updatePosition();

draw_set_valign(fa_middle);
draw_set_halign(fa_center);

draw_sprite_ext(sprite_index,0,centerPos.x,centerPos.y,image_xscale,image_yscale,image_angle,slider_bar_colour,1);

// Variable to either rotate the handle sprite to match the slider's image_angle or not
var _handleSpriteAngle = handle_rotate ? image_angle : 0;

var _handleScale = image_yscale*handle_sprite_scale;

draw_sprite_ext(handle_sprite,0,currentPos.x,currentPos.y,_handleScale,_handleScale,_handleSpriteAngle,handle_sprite_colour,1);

