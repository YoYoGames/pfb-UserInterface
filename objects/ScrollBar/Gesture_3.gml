dragging = true;
var _drag_min = -thumb_offset;
var _drag_max = bar_height-thumb_offset-thumb_height-end_padding-end_padding;
var _drag = -(event_data[?"viewstartposY"]-event_data[?"posY"]);
if(horizontal){
    _drag_max= bar_width-thumb_offset-thumb_width-end_padding-end_padding;
    _drag = -(event_data[?"viewstartposX"]-event_data[?"posX"]);
}
drag = clamp(_drag,_drag_min,_drag_max);
SetPosition(drag);