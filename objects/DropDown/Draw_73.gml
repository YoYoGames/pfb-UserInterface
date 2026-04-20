/// @description Draw the dropdown button and, if open, the dropdown list with all items

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(font);
if(open){
    if(!surface_exists(list_surf)){
		list_surf = surface_create(list_w,list_h);
	}
    surface_set_target(list_surf);
    	draw_clear_alpha(c_white, 1);
        draw_set_colour(item_colour);
        
        for (var i = 0; i < array_length(items); i++) {
            if(i == selected){
                draw_set_colour(selected_colour);
            } else {
                draw_set_colour(item_colour);
            }
            // if the text is too long then shrink it down to fit in the dropdown
            var _w = string_width(items[i])*font_scale;
            var _shrink = 1;
            if(_w > list_w){
                _shrink = (list_w/_w)*0.9;  // extra 10% smaller to add padding
            }
            draw_text_transformed(list_w/2,(item_h/2)+(i*(item_h)),items[i],font_scale*_shrink,font_scale*_shrink,0);
        }
    surface_reset_target();
    
    draw_sprite_stretched(dropdown_bg,0,x-floor(dd_w/2),y-dd_offset,dd_w,dd_h+(item_h/2));
	
	var _lines = shown_items;
	if(array_length(items) < shown_items){
		_lines = array_length(items);
	}
	
    if(dropdown_direction == "Up"){
        if(surface_exists(list_surf)){
        		draw_surface_part(list_surf,0,list_offset+drag,list_w,dd_h,x-dd_w/2,y-dd_offset);
    	}
        for (var i = 1; i < _lines; i++) {
            draw_line_width(x-((list_w*0.8)/2),y-dd_offset+(item_h*i),x+((list_w*0.8)/2),y-dd_offset+(item_h*i),1);
        }
    } else {
        if(surface_exists(list_surf)){
                draw_surface_part(list_surf,0,list_offset+drag,list_w,dd_h,x-dd_w/2,y+(item_h/2));
    	}
        for (var i = 1; i < _lines; i++) {
            draw_line_width(x-((list_w*0.8)/2),y+(item_h/2)+(item_h*i),x+((list_w*0.8)/2),y+(item_h/2)+(item_h*i),1);
        }
    }
}

draw_self();
draw_set_colour(selected_colour);
if(selected != undefined){
    // if the text is too long then shrink it down to fit in the dropdown
    var _w = string_width(items[selected])*font_scale;
	show_debug_message(string(_w))
    var _shrink = 1;
    if(_w > (sprite_width*0.5)){
        _shrink = ((sprite_width*0.5)/_w)*0.9;  // extra 10% smaller to add padding
    }
    draw_text_transformed(x-(sprite_get_height(sprite_index)/2),y,items[selected],font_scale*_shrink,font_scale*_shrink,0);
} else {
    draw_text_transformed(x-(sprite_get_height(sprite_index)/2),y,text,font_scale,font_scale,0);
}

if(show_icon){
    var _bx = x+(sprite_width/2)-(sprite_get_height(sprite_index)/2);
    var _by = y
    var _dir_offset = 0;
    if(dropdown_direction == "Up"){
        _dir_offset = 180;
    }
    if(open){
        draw_sprite_ext(icon_open,0,_bx,_by,icon_scale,icon_scale,image_angle-90+_dir_offset,icon_colour,image_alpha);
    } else {
        draw_sprite_ext(icon_open,0,_bx,_by,icon_scale,icon_scale,image_angle,icon_colour,image_alpha);
    }
}