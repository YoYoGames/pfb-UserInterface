/// @description Apply press scale to the button sprite, icon, and font, and mark as pressed

if(prevent_clickthrough){
	exit;
}
image_xscale *= press_scale;
image_yscale *= press_scale;
icon_scale *= press_scale;
font_scale *= press_scale;
pressed = true;