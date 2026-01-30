var _widthMatches = window_size.width == window_get_width();
var _heightMatches = window_size.height == window_get_height();

if (!_widthMatches || !_heightMatches){
    // Update the position of the slider
    updatePosition();
    
    window_size = { width: window_get_width(), height: window_get_height() }
}