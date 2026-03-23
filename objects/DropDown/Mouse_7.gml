/// @description Toggle dropdown open/closed and manage clickthrough prevention

open = !open;
if(open){
    opening = true;
	// prevent clickthrough
	var _x1 = x-floor(dd_w/2);
	var _y1 = y-dd_offset;
	var _x2 = _x1 + dd_w;
	var _y2 = _y1 + dd_h+(item_h/2);
	ds_list_clear(clickthrough_list);
	collision_rectangle_list(_x1, _y1, _x2, _y2, oUIParent, false, true, clickthrough_list, false);
	for(var _i=0; _i<ds_list_size(clickthrough_list); _i++){
		clickthrough_list[|_i].prevent_clickthrough = true;
	}
} else {
	closing = true;
	
	// Free up the memory for the surface once we ensure that it exists
	if (surface_exists(list_surf)){
		surface_free(list_surf);
	}
}