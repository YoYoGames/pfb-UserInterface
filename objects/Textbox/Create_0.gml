event_inherited();

clickInitiated = false;
hasFocus = false;

text_start_x_offset = 5;

// Variable to track the current position, so we know if we need to readjust any elements position
current = { x: x, y: y }

// Set the sprite colour to the value listed in the variable definition
image_blend = sprite_colour;

prevStringLength = 0;

// Initialise the text box dimensions
text_box_width = 0;
text_box_height = 0;

// Set the bounds that should be used for the text box
setBounds();

// Create the Text Element that we will be using to show our text
text_element = layer_text_create(layer,bounds.left,bounds.top,font,text);

// Set the text's position based on its alignment
setVerticalAlignmentPos();
layer_text_halign(text_element,horizontal_align);

font_size = font_get_size(font);
var _scale = text_size/font_size;
layer_text_xscale(text_element,_scale);
layer_text_yscale(text_element,_scale);

setTextboxSize();

layer_text_blend(text_element,text_colour);
layer_text_linespacing(text_element,line_separation);

draw_set_font(font)
caret_width = string_width("|")*_scale;

/// @desc This function will set the y-position of the Text Element to ensure that it is correctly shown within the confines of the Textbox
function setVerticalAlignmentPos()
{ 
	layer_text_valign(text_element,vertical_align);
	
	if (overflow_behaviour == "wrap")
	{
	    layer_text_wrap(text_element,true);
		
		var _font_size = font_get_size(font);
		
		// Adjust the y-position of the text if the text should scroll
		switch (vertical_align)
		{
			case fa_top:
				layer_text_y(text_element,bounds.top-text_size*0.5);
				break;
			case fa_middle:
				layer_text_y(text_element,bounds.top);
				break;
			case fa_bottom:
				layer_text_y(text_element,bounds.top+text_size*0.5);
		}
	} else if (overflow_behaviour == "scroll")
	{
	    layer_text_wrap(text_element,false);
		
		// Adjust the y-position of the text if the text should scroll
		switch (vertical_align)
		{
			case fa_top:
				layer_text_y(text_element,bounds.top);
				break;
			case fa_middle:
				layer_text_y(text_element,bounds.middle-text_size);
				break;
			case fa_bottom:
				layer_text_y(text_element,bounds.bottom-text_size*1.5);
		}
	}
}

/// @desc This function will calculate and set the boundary positions of the Textbox based on sprite dimensions and padding
function setBounds()
{
	w2 = sprite_width/2;
	h2 = sprite_height/2;

	bounds = {
	    left:   x-w2+horizontal_padding,
	    center: x,
	    right:  x+w2-horizontal_padding,
	    top:    y-h2+vertical_padding,
	    middle: y,
	    bottom: y+h2-vertical_padding
	}

	text_box_width = bounds.right-bounds.left;
	text_box_height = bounds.bottom-bounds.top;
}

/// @desc This function will set the text element's frame width and height which will then allow wrapping and alignment to be correctly updated
function setTextboxSize()
{
	var _scale = text_size/font_size; 
	layer_text_framew(text_element,text_box_width/_scale);
	layer_text_frameh(text_element,text_box_height/_scale);
}

/// @desc This function will recalculate the text elements position. This is called when the text box position changes but you can also call it directly if needed
function recalculateTextPosition()
{
	// Update the bounds that should be used for the text box
	setBounds();
	
	// Update the size (width and height) of the textbox on the Text Element
	setTextboxSize();
	
	// Set the x-position of the Text Element
	layer_text_x(text_element,bounds.left);
	
	// Set the y-position of the Text Element
	setVerticalAlignmentPos();
}

/// @desc This function validates and parses input string based on expected_input type ("all", "int", or "real")
/// @param {String} _input_string The input string to validate and parse
/// @returns {String} The validated string with invalid characters removed
function ParseInput(_input_string)
{
    // If the string is empty, just return
    if (string_length(_input_string) == 0) return;
		
	var _string_length = undefined;
	var _string_length_digits = undefined;
	var _contains_minus = undefined;
        
    switch (expected_input)
    {
        case "all":
            return _input_string;
        
        case "int":
            // Get values for the string length and the length of the string only counting numbers
            _string_length = string_length(_input_string);
            _string_length_digits = string_length(string_digits(_input_string));
			
            // Get booleans for whether the string includes a starting minus
            _contains_minus = string_char_at(_input_string,1) == "-";
        
            // While the string contains characters that are not numbers
            while (_string_length_digits != _string_length-_contains_minus)
            {
                // Remove the last character from the string
                _input_string = string_delete(_input_string,_string_length,1)
            
                // Update the values for the string length and the length of the string only counting numbers
                _string_length = string_length(_input_string);
                _string_length_digits = string_length(string_digits(_input_string));
				
				_contains_minus = string_char_at(_input_string,1) == "-";
            }
            return string(_input_string)
        
        case "real":
            // Get values for the string length and the length of the string only counting numbers
            _string_length = string_length(_input_string);
            _string_length_digits = string_length(string_digits(_input_string));
        
            // Get booleans for whether the string includes a starting minus or a decimal point anywhere
            _contains_minus = string_char_at(_input_string,1) == "-";
            var _contains_decimal_point = string_pos(".",_input_string) != 0;
        
            // Loop through the string if the format does not match expectation
            while (_string_length_digits != (_string_length-_contains_minus-_contains_decimal_point))
            {
                // Remove the last character from the string
                _input_string = string_delete(_input_string,_string_length,1)
            
                // Update the values that will be used to decide if the while loop should continue
                _string_length = string_length(_input_string);
                _string_length_digits = string_length(string_digits(_input_string));
        
                _contains_minus = string_char_at(_input_string,1) == "-";
                _contains_decimal_point = string_pos(".",_input_string) != 0;
            }
            return string(_input_string)
    }
}

/// @desc This function returns the alpha part of the given colour, with the value being between 0 and 255, where 0 is completely transparent and 255 is completely opaque. If an alpha is not present (for example, in a constant like c_red) then the value 0 will be returned.
/// @param {Real} _colour the colour to check
/// @returns {Real} Alpha value (0 - 255)
function colour_get_alpha(_colour)
{
    // For more information on the code in this function, you can go to the Bitwise Operators page of the manual
    // https://manual.gamemaker.io/monthly/en/#t=Additional_Information%2FBitwise_Operators.htm
    
    // The colour value is made of 4 sets of 8 bits to represent Alpha, Blue, Green, Red where 00000000 = 0 and 11111111 = 255
    // For this example, we will use the following value #7EE8AA2F
    // Alpha    Blue     Green    Red
    // 126      232      170      47
    // 01111110 11101000 10101010 00101111
    
    // Using the 'right shift operator' on the above example, we can move the Alpha bits down, so that the value becomes only the Alpha
    // As an example, below we move the bits right by 8, 16, and then 24
    // Alpha    Blue     Green    Red
    // 01111110 11101000 10101010 00101111 (original value)
    // 00000000 01111110 11101000 10101010 (original value >> 8)
    // 00000000 00000000 01111110 11101000 (original value >> 16)
    // 00000000 00000000 00000000 01111110 (original value >> 24)
    
    return _colour>>24;
}

/// @desc This function updates the text that is present in the textbox, it can either be a string that is set directly or it can be a localisation string name
/// @param {String} _newText The string that should be shown, or the Localisation table entry name
/// @param {Bool} isLocalised Whether the string should be considered a localisation_string (default is false)
function updateText(_newText, isLocalised = false)
{ 
	if (isLocalised){
		localisation_string = _newText
		setText();
	} else {
		localisation_string = undefined;
		text = _newText;
	}
	
}

/// @desc Default callback function that is called when the textbox loses focus (can be overridden by interaction_end_function)
onInteractionEnd = function(){
    show_debug_message("Textbox Interaction End");
}

/// @desc This function will handle what should happen when the textbox loses focus
function endInteraction()
{
	hasFocus = false;
    
    // Clear the value of keyboard_string
    keyboard_string = "";
	
	// If the user is on a mobile device
	if (os_type == os_android || os_type == os_ios){
		// Hide the virtual keyboard
		keyboard_virtual_hide();
	}
	 
    if(!is_undefined(interaction_end_function)){
        method_call(interaction_end_function);
    } else {
        method_call(onInteractionEnd);
    }
}

/// @desc This function will enable the virtual keyboard on the device, no change will occur if the virtual keyboard is already open
///       It will show either the default keyboard or the numberpad depending on the value of expected_input
function showVirtualKeyboard()
{ 
	
	if(expected_input == "int") { 
		// If the expected_input is an integer, show the full keyboard to allow negative numbers
	    keyboard_virtual_show(kbv_type_default,kbv_returnkey_default,kbv_autocapitalize_none,false);
    } else {
		// Else expected_input is either real or will allow all characters, so show the full keyboard 
		keyboard_virtual_show(kbv_type_default,kbv_returnkey_default,kbv_autocapitalize_none,false);
	}
}