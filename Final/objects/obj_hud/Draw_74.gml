for(i = 0; i < ds_list_size(elements); i++){
	if (!ds_list_empty(elements)) {
		elements[i].draw();
	}
}