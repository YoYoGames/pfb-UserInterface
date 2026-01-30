/// @description Set a value to track that the textbox has been clicked if the TextBox is set to be editable
if(prevent_clickthrough){
	exit;
}

if (editable){
	clickInitiated = true;
	localisation_string = undefined;
}