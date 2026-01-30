draw_set_colour(bar_colour);
draw_sprite_ext(bar_sprite,0,x,y,image_xscale,image_yscale,image_angle,bar_colour,image_alpha);
var _tx = x-(thumb_width/2);
var _ty = scroll_top+thumb_offset+drag;
if(horizontal){
    _tx = scroll_top+thumb_offset+drag;
    _ty = y-(thumb_height/2);
}
draw_sprite_stretched_ext(thumb_sprite,0,_tx,_ty,thumb_width,thumb_height,thumb_colour,image_alpha);