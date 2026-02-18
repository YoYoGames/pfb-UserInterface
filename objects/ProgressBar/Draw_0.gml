/// @description Draw the progress bar background sprite and the progress bar foreground sprite scaled to show current progress

draw_self();
draw_set_halign(fa_center);

// Get the value based on the current and max values
// Note: value clamping is done in the 'set' functions
var _progress_normalised = (current_value/max_value);

var _progress_bar_width =  sprite_width*_progress_normalised/2;

var _progressBarMiddle = sprite_width/2-_progress_bar_width;

var _progressMiddleX = x-lengthdir_x(_progressBarMiddle,-image_angle)
var _progressMiddleY = y+lengthdir_y(_progressBarMiddle,-image_angle)

draw_sprite_ext(progress_bar_sprite,0,_progressMiddleX,_progressMiddleY,image_xscale*_progress_normalised,image_yscale,image_angle,progress_bar_sprite_colour,1);