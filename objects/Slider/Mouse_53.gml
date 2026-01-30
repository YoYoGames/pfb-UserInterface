if(prevent_clickthrough){
	exit;
}

// Compare the click location to the pixel width of the handle (based on the handle sprite's width and its scale)
if (point_distance(currentPos.x,currentPos.y,mouse_x,mouse_y)<(image_yscale*handle_width)/2){
	has_focus = true;
}