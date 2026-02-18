/// @description Set the textbox to have focus and the current content to be keyboard_string when the textbox is clicked

if(prevent_clickthrough){
	exit;
}

var _mouseOverSelf = collision_point(mouse_x, mouse_y, id, false, false);

// If the user has clicked and is now releasing with the mouse still over the text box
if (_mouseOverSelf != noone){
    if (clickInitiated){
        hasFocus = true;
    
        keyboard_string = text;
		
		// If the user is on a mobile device
		if (os_type == os_android || os_type == os_ios){
			// show the OS's virtual keyboard
			showVirtualKeyboard();
		}
    }
} else {
    hasFocus = false;

	// If the user is on a mobile device
	if (os_type == os_android || os_type == os_ios){
		// 
		var _mouseOverAny = collision_point(mouse_x, mouse_y, all, false, false);
		
		if (_mouseOverAny == noone)
		{
			// Hide the virtual keyboard
			keyboard_virtual_hide();
		}
	}
}

clickInitiated = false;