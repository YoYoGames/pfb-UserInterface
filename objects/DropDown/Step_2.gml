if(opening){
    opening = false;
}
if(closing){
	for(var _i=0; _i<ds_list_size(clickthrough_list); _i++){
		clickthrough_list[|_i].prevent_clickthrough = false;
	}
	closing = false;
}