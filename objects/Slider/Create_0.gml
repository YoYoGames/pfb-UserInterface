// Initialise the positions of the slider to be the centre of the object
slider_length = 0;
centerPos = { x: x, y: y };
startPos = { x: x, y: y };
endPos = { x: x, y: y };
currentPos = { x: x, y: y };

window_size = { width: window_get_width(), height: window_get_height() }

// Get the value range that the slider represents
slider_value_range = abs(max_value-min_value);

// Update the position of the slider
updatePosition();

// Set the focus value to false, as the slider will only have focus while it is being dragged
has_focus = false;

// Get the pixel width of the handle based on the sprite and its scale
handle_width = sprite_get_width(handle_sprite)*handle_sprite_scale;

/// @desc This function will return the current value of the slider
/// @returns {Real} The current value of the slider
function getValue()
{
    return current_value;
}

/// @desc This function will set the current value of the slider
/// @param {Real} _newValue The new value of the slider
function setValue(_newValue)
{
	current_value = _newValue;
}

/// @desc This function will return the value's position on the slider as a normalised value between 0.0 and 1.0
/// @param {Real} _value The value we want to get the position of
/// @return {Real} The value that has been provided as a normalised value between 0.0 and 1.0
function getValuePosition(_value)
{
    var _valueAboveMinimum = _value-min_value;
    return (_valueAboveMinimum)*(slider_length/slider_value_range);
}

/// @desc This function will return the minimum value of the slider
/// @returns {Real} The minimum value of the slider
function getMinValue()
{
    return min_value;
}

/// @desc This function will set the minimum value of the slider
/// @param {Real} _newValue The new minimum value of the slider
function setMinValue(_newValue)
{
    min_value = _newValue;
}

/// @desc This function will return the maximum value of the slider
/// @returns {Real} The maximum value of the slider
function getMaxValue()
{
    return max_value;
}

/// @desc This function will set the maximum value of the slider
/// @param {Real} _newValue The new maximum value of the slider
function setMaxValue(_newValue)
{
    max_value = _newValue;
}

/// @desc This function will update the slider thumb position based on new coordinates and recalculate the current value
/// @param {Real} _newPosX The new X position of the slider thumb
/// @param {Real} _newPosY The new Y position of the slider thumb
/// @returns {Bool} Returns true when the position update is complete
function updateSliderThumbPos(_newPosX, _newPosY)
{
	// Calculate the distance from start to the new position
	var _distX = _newPosX-startPos.x;
	var _distY = _newPosY-startPos.y;
	var _distanceFromStart = sqrt(sqr(_distX)+sqr(_distY));

	// Calculate the total length of the slider
	var _totalLength = sqrt(sqr(slider_length.x)+sqr(slider_length.y));

	// Calculate how far along the slider we are (0 to 1)
	var _sliderPos = (_totalLength > 0) ? _distanceFromStart/_totalLength : 0;

	// Clamp to keep on the slider
	_sliderPos = clamp(_sliderPos,0,1);

	if (slider_step_size > 0){
		// Calculate the number of steps along the slider the handle should snap to
		var _steps_along = round(_distanceFromStart/slider_step_size);

		// Calculate how far the thumb is from the starting point
		_distanceFromStart = _steps_along*slider_step_size;

		// Get the distance to the proposed snap point
		var _snapPosX = startPos.x+(_steps_along*slider_step_size/_totalLength)*slider_length.x;
		var _snapPosY = startPos.y+(_steps_along*slider_step_size/_totalLength)*slider_length.y;
		var _distance_to_step = point_distance(_newPosX,_newPosY,_snapPosX,_snapPosY);

	    // Get the distance to the end of the slider
	    var _distance_to_end = point_distance(_newPosX,_newPosY,endPos.x,endPos.y);

	    // If closer to the end than to the last step, snap to end
	    if (_distance_to_step > _distance_to_end)
	    {
	        _steps_along++;
	    }

	    // Set the value and new position based on the steps_along value
	    var _value = min_value+_steps_along*step_size;
		_sliderPos = clamp(_steps_along*slider_step_size/_totalLength, 0, 1);
	}

	// Update the current position based on the slider position
	currentPos.x = startPos.x+(_sliderPos*slider_length.x);
	currentPos.y = startPos.y+(_sliderPos*slider_length.y);

	// Calculate and set the value
	var _value = min_value+(_sliderPos*slider_value_range);
	current_value = clamp(_value,min_value,max_value);

    return true;
}

/// @desc This function will update the size and position of the slider, as its placement may differ if the room size changes
function updatePosition()
{
    centerPos = { x: x, y: y };
	
	// Get the current value as a normalised value (between 0.0 and 1.0)
	var _progress_normalised = ((current_value-min_value)/(max_value-min_value));

	var _barLengthX = lengthdir_x(sprite_width-2*padding,-image_angle);
	var _barLengthY = lengthdir_y(sprite_width-2*padding,-image_angle);

	startPos = { x: x - _barLengthX/2, y: y + _barLengthY/2 }
	endPos = { x: x + _barLengthX/2, y: y - _barLengthY/2 }
	slider_length = { x: endPos.x-startPos.x, y: endPos.y-startPos.y }
	currentPos = { x: startPos.x+(_progress_normalised*slider_length.x), y: startPos.y+(_progress_normalised*slider_length.y)}

    // Initialise the value
    slider_step_size = 0;

    // If the Variable Definition lists a num_steps, this value should override the step_size value
    if (num_steps > 0){
        step_size = slider_value_range/num_steps;
    }

    // If the Variable Definition lists a step_size or it was set above based on the num_steps value
    if (step_size > 0){
		slider_step_size = (sqrt(sqr(slider_length.x)+sqr(slider_length.y))/slider_value_range)*step_size;
    }
}

/// @desc Default callback function that is called when the slider interaction ends (can be overridden by interaction_end_function)
onInteractionEnd = function(){
    show_debug_message($"Slider Interaction End  {string(current_value)}");
}

/// @desc This function will handle what should happen when the slider loses focus
function endInteraction()
{
	// Set the slider to no longer have focus when the user releases the mouse
	if (has_focus){
    	has_focus = false;
		
		if(!is_undefined(interaction_end_function)){
        	method_call(interaction_end_function);
    	} else {
        	method_call(onInteractionEnd);
    	}
	}
}