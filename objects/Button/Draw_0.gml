/// @description Draw the button sprite, then draw either the icon or text centered on the button

draw_self();

if(icon != noone){
    draw_sprite_ext(icon,0,x,y,icon_scale,icon_scale,image_angle,colour,1);
} else {
    draw_set_valign(fa_middle);
    draw_set_halign(fa_center);
    draw_set_font(font);
    draw_set_colour(colour);
    draw_text_transformed(x,y,text,font_scale,font_scale,image_angle);
}