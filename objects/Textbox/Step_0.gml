/// @description If the textbox has focus, ensure the string content still matches our expectations

if (hasFocus){
    // If the string length has changed
    if (string_length(keyboard_string) != prevStringLength){
        keyboard_string = ParseInput(keyboard_string);
        text = keyboard_string;
        
        prevStringLength = string_length(keyboard_string);
    }
    
    // Check on iOS as they will not recognise if you press the enter/return button on the keyboard
    if((os_type == os_ios) && (keyboard_check_pressed(13) || keyboard_key==10)){
        endInteraction();
    }
}

if (x != current.x || y != current.y)
{
	recalculateTextPosition();
	
	current = { x: x, y: y };
}