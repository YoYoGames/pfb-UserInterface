// Set the sprite colour to the value listed in the variable definition
image_blend = background_sprite_colour;

current_value = 0;

/// @desc This function will get the current value of the progress bar
/// @returns {Real} The current value of the progress bar
function getCurrentValue()
{
    return current_value;
}

/// @desc This function will set the current value of the progress bar, and clamp it based on max_value
/// @param {Real} _new_value the value that current_value should be set to (subject to clamping)
function setCurrentValue(_new_value)
{
    current_value = clamp(_new_value,0,max_value);
}

/// @desc This function will get the max value of the progress bar
/// @returns {Real} The max value of the progress bar
function getMaxValue()
{
    return max_value;
}

/// @desc This function will set the maximum value of the progress bar, and clamp the current_value to ensure it doesn't overflow
/// @param {Real} _new_value the value that max_value should be set to 
function setMaxValue(_new_value)
{
    max_value = _new_value;
    current_value = clamp(current_value,0,max_value);
}