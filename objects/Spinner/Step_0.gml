/// @description Play or pause the spinner animation based on the spinning variable

if(spinning){
    layer_sequence_play(animation);
} else {
    layer_sequence_pause(animation);
}