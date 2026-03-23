// If there is still a surface for the open dropdown, then free up the memory
if (surface_exists(list_surf)){
	surface_free(list_surf);
}