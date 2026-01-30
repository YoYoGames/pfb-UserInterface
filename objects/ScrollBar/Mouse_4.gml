if(horizontal){
    percentage = (mouse_x-scroll_top) / (scroll_bottom-scroll_top);
    thumb_offset = percentage*(bar_width-thumb_width);
} else {
    percentage = (mouse_y-scroll_top) / (scroll_bottom-scroll_top);
    thumb_offset = percentage*(bar_height-thumb_height);
}