/// @description When this mouse is over the infobox's area, calculate exactly where it should be shown in the room so it is fully shown within the window

if(prevent_clickthrough){
	exit;
}
show_debug_message("Entered!")

visible_infobox = true;

// Update the origin point of the infobox based on the mouse's position
infobox_x = mouse_x;
infobox_y = mouse_y;

// Get the width and height of the window
var window_width = window_get_width();
var window_height = window_get_height();

var _window_mouse_x = window_mouse_get_x();
var _window_mouse_y = window_mouse_get_y();

// Adjust the x position of the infobox if it is going to overflow to the left of the window
infobox_x += reposition_infobox_to_window(window_width,0,_window_mouse_x,infobox_width,infobox_width/2-infobox_x_offset);

// Adjust the x position of the infobox if it is going to overflow to the right of the window
infobox_x -= reposition_infobox_to_window(window_width,window_width,_window_mouse_x,infobox_width,infobox_width/2+infobox_x_offset);

// Adjust the y position of the infobox if it is going to overflow to the top of the window
infobox_y += reposition_infobox_to_window(window_height,0,_window_mouse_y,infobox_height,infobox_height/2-infobox_y_offset);

// Adjust the y position of the infobox if it is going to overflow to the bottom of the window
infobox_y -= reposition_infobox_to_window(window_height,window_height,_window_mouse_y,infobox_height,infobox_height/2+infobox_y_offset);

/// @desc This function will return the number of pixels the provided screen edge that a infobox overlaps, so that it can be adjusted
/// @param {Real} _window_size The size (width or height) of the window
/// @param {Real} _window_edge_pos The position (x or y) of the screen edge (for top or left this will be 0, otherwise it is window width/height)
/// @param {Real} _infobox_pos the window position of the default infobox center
/// @param {Real} _infobox_size the size (width or height) of the infobox
/// @param {Real} _infobox_origin the origin (x or y) of the infobox offset from the default infobox center
/// @returns {Real} pixel value of the overlap
function reposition_infobox_to_window(_window_size, _window_edge_pos, _infobox_pos, _infobox_size, _infobox_origin)
{
    // Only adjust it if the infobox is narrower than the window
    if (_infobox_size < _window_size){
        var space_to_window_edge = abs(_infobox_pos-_window_edge_pos);
        var adjust_amount = clamp(_infobox_origin-space_to_window_edge,0,1000);

        return adjust_amount;
    }
    
    // Otherwise return 0;
    return 0;
}