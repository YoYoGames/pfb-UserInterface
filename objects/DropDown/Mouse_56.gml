if(open){
    if((dropdown_direction == "Down") && (point_in_rectangle(mouse_x,mouse_y,bbox_right-dd_w,bbox_bottom,bbox_right,bbox_bottom+dd_h))){
        selected = (mouse_y - bbox_bottom + list_offset) div item_h;
        open = false;
		closing = true;
    } else if((dropdown_direction == "Up") && (point_in_rectangle(mouse_x,mouse_y,bbox_right-dd_w,bbox_top-dd_offset+(item_h/2),bbox_right,bbox_top))){
        selected = (mouse_y - (bbox_top-dd_offset+(item_h/2)) + list_offset) div item_h;
        open = false;
		closing = true;
    } else {
        if(!opening){
            open = false;
			closing = true;
        }
    }
	if(surface_exists(list_surf)){
		surface_free(list_surf);
	}
}