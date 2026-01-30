event_inherited();
items = array_create(0,0);
items[0] = "Item 1";
items[1] = "Item 2";
items[2] = "Item 3";
items[3] = "Item 4";
items[4] = "Item 5";
items[5] = "Item 6";

open = false;
opening = false;
closing = false;
selected = undefined;
item_h = 0;
item_w = 0;
list_w = 0;
list_h = 0;
list_offset = 0;

dd_w = 0;
dd_h = 0;
dd_offset = 0;

drag = 0;
percentage = 0;
step_size = 0.1;

base_font_scale = text_size/font_get_size(font);
font_scale = base_font_scale;

list_surf = undefined;

clickthrough_list = ds_list_create();

Scroll = function(_size){
    if(array_length(items) > shown_items){
        percentage = clamp(percentage+_size,0,1-(step_size*shown_items));
        list_offset = percentage*(list_h);
    }
}

SetDirection = function(){
	// check if the dropdown would be outside the view/room, then flip direction if required
	var _cam = view_get_camera(view_current);
	var _outside_view = false;
	var _outside_room = false;
	
	if(_cam != -1) && view_enabled{
		var _y = camera_get_view_y(_cam);
		var _h = camera_get_view_height(_cam);
		if(bbox_bottom+dd_h > _y + _h){
			_outside_view = true;
		}
	} else {
		if(bbox_bottom+dd_h > room_height){
			_outside_room = true;
		}
	}
	
    if(_outside_room) || (_outside_view){
        dropdown_direction = "Up";
        dd_offset = dd_h+(sprite_height/2);
    } else {
        dropdown_direction = "Down";
        dd_offset = 0;
    }
}


ResizeList = function() {
    draw_set_font(font);
    for(var i=0;i<array_length(items);i++){
        var _text_height = string_height(items[i]);
        if(_text_height > item_h){
			item_h = _text_height;
		}
	}
    item_h = sprite_height;
    list_w = sprite_width;
    // auto expand list width to fit items - dropdown no longer hidden behind button
    /*
    for(var _i=0; _i<array_length(items); _i++){
        var _w = string_width(items[_i]);
        if(_w > list_w){
            list_w = _w;
        }
    } 
    */
    list_h = (array_length(items) * item_h);
    dd_w = list_w;
    
    if(array_length(items) < shown_items){
        show_scroll = false;
        dd_h = list_h;
    } else {
        dd_h = (shown_items * (item_h));
    }
    
    SetDirection();
    
    step_size = item_h/list_h;
	if(surface_exists(list_surf)){
		surface_free(list_surf);
	}
    list_surf = surface_create(list_w,list_h);
}

FillList = function(_list){
    array_resize(items,0);
    for(var l=0;l<array_length(_list);l++){
		items[l] = _list[l];
	}
    ResizeList();
}

ResizeList();