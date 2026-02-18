/// @description Finalize the drag position when the gesture ends

if(dragging){
    dragging = false;
    thumb_offset += drag;
    drag=0;
}