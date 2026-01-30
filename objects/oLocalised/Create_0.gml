setText();

function setText()
{
	// If localisation_string is set
	if (!is_undefined(localisation_string) && string_length(localisation_string) > 0)
	{
		// Set text to be the localised string or show 'string not found' if there was not a matching entry
		var _localisedString = GetLocalisation(localisation_string);
		text = (!is_undefined(_localisedString)) ? _localisedString : "string not found";
	}
}