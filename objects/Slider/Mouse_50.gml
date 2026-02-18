/// @description Update slider thumb position based on mouse position while dragging

if (has_focus){
    // Calculate the perpendicular intersection point on the slider
    // Vector from slider start to slider end
    var _abX = endPos.x-startPos.x;
    var _abY = endPos.y-startPos.y;

    // Vector from slider start to mouse position
    var _apX = mouse_x-startPos.x;
    var _apY = mouse_y-startPos.y;

    // Calculate projection parameter t
    var _abLengthSquared = (_abX*_abX)+(_abY*_abY);
    var _t = ((_apX*_abX)+(_apY*_abY))/_abLengthSquared;

    // Clamp t to keep the point on the line segment
    _t = clamp(_t,0,1);

    // Calculate the intersection point
    var _intersectX = startPos.x+(_t*_abX);
    var _intersectY = startPos.y+(_t*_abY);

    // Update slider with the perpendicular intersection point
    updateSliderThumbPos(_intersectX,_intersectY);
}

