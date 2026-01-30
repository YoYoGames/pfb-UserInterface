animation = layer_sequence_create(layer,x,y,animation_sequence);
layer_sequence_xscale(animation,image_xscale);
layer_sequence_yscale(animation,image_yscale);
layer_sequence_angle(animation,image_angle);
layer_sequence_speedscale(animation,animation_speed);
var _seq_struct = layer_sequence_get_instance(animation);
_seq_struct.sequence.tracks[0].keyframes[0].channels[0].spriteIndex = animation_sprite;

// Get the individual parts of the instance's colour value
var _r = colour_get_red(image_blend) / 255;
var _g = colour_get_green(image_blend) / 255;
var _b = colour_get_blue(image_blend) / 255;
colour_array = [1,_r,_g,_b];

// Set the colour value of the animation_sprite
_seq_struct.sequence.tracks[0].tracks[4].keyframes[0].channels[0].colour = colour_array;