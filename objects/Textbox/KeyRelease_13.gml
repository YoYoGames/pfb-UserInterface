/// @description Set the textbox to no longer have focus

if (hasFocus){
    hasFocus = false;
    
    // Clear the value of keyboard_string
    keyboard_string = "";
	
	// If the user is on a mobile device
	if (os_type == os_android || os_type == os_ios){
		// Hide the virtual keyboard
		keyboard_virtual_hide();
	}
}