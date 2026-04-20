/// @description Draw the text box and its contents, with the chosen highlight colour if the textbox has focus

draw_self();

if(prevent_clickthrough){
	hasFocus = false;
}

var _scale = text_size/font_size;

var _stringToRender = text;

draw_set_font(font);

// If the textbox has focus and the caret should be visible then its width should be accounted for
var _caret_width = hasFocus*caret_visible*caret_width;

if (overflow_behaviour == "scroll"){
    // ensure that the text doesn't overflow the box by removing characters from the start of the string that we are showing
    while (string_width(_stringToRender)*_scale+_caret_width >= text_box_width){
        _stringToRender = string_delete(_stringToRender,0,1);
    }
}

if (hasFocus) 
{ 
    // Get the alpha value from the highlight colour
   var _highlight_alpha = get_textbox_highlight_alpha(highlight_colour)/255;
    draw_sprite_ext(sprite_index,0,x,y,image_xscale,image_yscale,0,highlight_colour,_highlight_alpha);

    if (caret_visible){
        _stringToRender += "|"
    }
}

layer_text_text(text_element,_stringToRender);