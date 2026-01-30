horizontal = false;
bar_width = sprite_width;
bar_height = sprite_height;
if(bar_width > bar_height){
    horizontal = true;
}
thumb_scale = sprite_get_width(thumb_sprite)/sprite_get_width(bar_sprite);
end_padding = ((sprite_get_width(bar_sprite)-sprite_get_width(thumb_sprite))/2)/thumb_scale;

thumb_offset = 0;
thumb_width = bar_width*thumb_scale;
thumb_height = bar_height*step_size;

scroll_top = y-(bar_height/2)+end_padding;
scroll_bottom = y+(bar_height/2)-end_padding;

if(horizontal){
    scroll_top = x-(bar_width/2)+end_padding;
    scroll_bottom = x+(bar_width/2)-end_padding;
    thumb_height = bar_height*thumb_scale;
    thumb_width = bar_width*step_size;
}

drag = 0;
dragging = false;

Scroll = function(_size){
    percentage = clamp(percentage+_size,0,1)
    if(horizontal){
        thumb_offset = percentage*(bar_width-thumb_width-end_padding-end_padding);
    } else {
        thumb_offset = percentage*(bar_height-thumb_height-end_padding-end_padding);
    }
}

SetPosition = function(_position){
    if(horizontal){
        percentage = clamp((mouse_x-scroll_top) / (scroll_bottom-scroll_top),0,1);
    } else {
        percentage = clamp((mouse_y-scroll_top) / (scroll_bottom-scroll_top),0,1);
    }
}