/// @description Create the toggle animation sequence and configure sprites, colors, and initial state

unchecked_sprite = sprite_index;

animation = layer_sequence_create(layer,x,y,animation_sequence);
layer_sequence_xscale(animation,image_xscale);
layer_sequence_yscale(animation,image_yscale);
layer_sequence_angle(animation,image_angle);
var _seq_struct = layer_sequence_get_instance(animation);
// set sprites
_seq_struct.sequence.tracks[0].keyframes[0].channels[0].spriteIndex = check_bg;
_seq_struct.sequence.tracks[1].keyframes[0].channels[0].spriteIndex = unchecked_sprite;
_seq_struct.sequence.tracks[2].keyframes[0].channels[0].spriteIndex = check_sprite;
_seq_struct.sequence.tracks[2].tracks[0].keyframes[0].channels[0].value = check_scale;
_seq_struct.sequence.tracks[2].tracks[0].keyframes[0].channels[1].value = check_scale;
_seq_struct.sequence.tracks[3].keyframes[0].channels[0].spriteIndex = frame;

// set colours
if((colour_area == "Background") || (colour_area == "Both")){
    _seq_struct.sequence.tracks[0].tracks[4].keyframes[0].channels[0].colour = background_unchecked_colour;
    _seq_struct.sequence.tracks[0].tracks[4].keyframes[1].channels[0].colour = background_checked_colour;
    if(colour_area == "Background"){
        _seq_struct.sequence.tracks[2].tracks[4].keyframes[0].channels[0].colour = dot_default_colour;
        _seq_struct.sequence.tracks[2].tracks[4].keyframes[1].channels[0].colour = dot_default_colour;
    }
}

if((colour_area == "Dot") || (colour_area == "Both")){
    _seq_struct.sequence.tracks[2].tracks[4].keyframes[0].channels[0].colour = dot_unchecked_colour;
    _seq_struct.sequence.tracks[2].tracks[4].keyframes[1].channels[0].colour = dot_checked_colour;
    if(colour_area == "Dot"){
        _seq_struct.sequence.tracks[0].tracks[4].keyframes[0].channels[0].colour = background_default_colour;
        _seq_struct.sequence.tracks[0].tracks[4].keyframes[1].channels[0].colour = background_default_colour;
    }
}

layer_sequence_pause(animation);

pressed = false;