function pythagoras(val1, val2){
	return sqrt((val1) + (val2));
}

function magnitude(x_length, y_length){
	return pythagoras(x_length*x_length, y_length*y_length);
}

function wrap(val, min, max){
	return val - (max - min) * floor( val / (max - min));
}

function ds_list_contains(id, value){
	return ds_list_find_index(id, value)!=-1 ? false: true;
}

function ds_list_transfer(source, id, value){
	ds_list_add(id, value);
	ds_list_delete(source, value);
}

function ds_stack_shuffle(id){
	var list = ds_list_create();
	var size = ds_stack_size(id);
	repeat(size-1){
		var item = ds_stack_pop(id);
		ds_list_add(list, item);
	}
	ds_list_shuffle(list);
	for(var i = 0; i < size; i++){
		var item = ds_list_find_value(list, i);
		ds_stack_push(id, item);
	}
	ds_list_destroy(list);
}
#region grid utils
//credit for this one in particular to u/PixelatedPope https://old.reddit.com/r/gamemaker/comments/1wi4vy/helpgml_deleting_a_row_from_ds_grid/
function ds_grid_delete_row(grid, row){
	var grid_width = ds_grid_width(grid);
	var grid_height = ds_grid_height(grid);
	
	ds_grid_set_grid_region(grid, grid, 0, row+1, grid_width-1, grid_height-1, 0, row);
	ds_grid_resize(grid, grid_width, grid_height-1);
}
function ds_grid_mirror_horizontal(grid){
	var grid_width = ds_grid_width(grid)
	var grid_height = ds_grid_height(grid)
	
	var new_grid = ds_grid_create(grid_width, grid_height)

	for (var i = 0; i < grid_width; ++i) {
	    for (var n = 0; n < grid_height; ++n) {
		    new_grid[# i,n] = grid[# grid_width-i-1, n]
		}
	}
	ds_grid_copy(grid, new_grid);
	ds_grid_destroy(new_grid);
}
function ds_grid_mirror_vertical(grid){
	var grid_width = ds_grid_width(grid)
	var grid_height = ds_grid_height(grid)
	
	var new_grid = ds_grid_create(grid_width, grid_height)

	for (var i = 0; i < grid_width; ++i) {
	    for (var n = 0; n < grid_height; ++n) {
		    new_grid[# i,n] = grid[# n, grid_height-i-1]
		}
	}
	ds_grid_copy(grid, new_grid);
	ds_grid_destroy(new_grid);
}
#endregion