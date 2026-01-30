event_inherited();

visible_infobox = false;

draw_set_font(font);

font_scale = text_size/font_get_size(font);

// Calculate the required scale for the infobox based on the text it will contain
required_frame_xscale = (string_width(text)*font_scale+horizontal_padding*2)/sprite_get_width(infobox_sprite);
required_frame_yscale = (string_height(text)*font_scale+vertical_padding*2)/sprite_get_height(infobox_sprite);

// Variables that will define the origin point of the infobox when shown
infobox_x = x;
infobox_y = y;

// Define the width and height
infobox_width = sprite_get_width(infobox_sprite)*required_frame_xscale;
infobox_height = sprite_get_height(infobox_sprite)*required_frame_yscale;

// Set the offset position of the infobox to default to be centred
infobox_x_offset = 0;
infobox_y_offset = 0;

// Adjust the horizontal offset if the user has selected an option other than center
switch (horizontal_align)
{
    case fa_left:
        infobox_x_offset = -infobox_width/2;
    break;
    
    case fa_right:
        infobox_x_offset = infobox_width/2;
    break;
}

// Adjust the vertical offset if the user has selected an option other than middle
switch (vertical_align)
{
    case fa_top:
        infobox_y_offset = -infobox_height/2;
    break;
    
    case fa_bottom:
        infobox_y_offset = infobox_height/2;
    break;
}