/// @description Scroll the dropdown list upward if the mouse is over it

if(open){
    if(point_in_rectangle(mouse_x,mouse_y,bbox_right-dd_w,bbox_top-dd_offset,bbox_right,bbox_bottom-dd_offset+dd_h)){
        Scroll(-step_size);
    }
}