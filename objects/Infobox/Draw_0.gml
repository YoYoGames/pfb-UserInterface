/// @description When the mouse is over the infobox's area, draw it to the screen

draw_self();

if (visible_infobox)
{
    draw_sprite_ext(infobox_sprite, 0, infobox_x + infobox_x_offset, infobox_y + infobox_y_offset, required_frame_xscale, required_frame_yscale, 0, infobox_colour, 1);
    
    draw_set_font(font);
    draw_set_valign(fa_middle);
    draw_set_halign(fa_center);
    draw_set_color(text_colour);
    draw_text_transformed(infobox_x + infobox_x_offset, infobox_y + infobox_y_offset, string(text), font_scale, font_scale, 0);
    draw_set_color(c_white);
}