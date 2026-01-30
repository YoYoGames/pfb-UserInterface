if(pressed){
	checked = !checked;
    if(checked){
        sprite_index = check_bg;
        if(!is_undefined(animation)){
            layer_sequence_headdir(animation,seqdir_right);
        }
    } else {
        sprite_index = unchecked_sprite;
        if(!is_undefined(animation)){
            layer_sequence_headdir(animation,seqdir_left);
            layer_sequence_headpos(animation,10);
        }
    }
    layer_sequence_play(animation);
}