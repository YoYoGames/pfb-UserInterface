/// @description Draw the checkbox background sprite and the check sprite if checked

draw_self();
if(checked){
    draw_sprite_ext(check_sprite,image_index,x,y,image_xscale*check_scale,image_yscale*check_scale,image_angle,check_colour,image_alpha);
}