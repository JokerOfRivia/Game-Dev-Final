function toggle_fullscreen() {
	window_set_fullscreen(!window_get_fullscreen());
}

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
	return ds_list_find_index(id, value)!=-1 ? true: false;
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

function keytostring(key){	
	switch key
	{
		case	65:		return "A"       
		case	66:		return "B"       
		case	67:		return "C"       
		case	68:		return "D"       
		case	69:		return "E"       
		case	70:		return "F"       
		case	71:		return "G"       
		case	72:		return "H"       
		case	73:		return "I"       
		case	74:		return "J"       
		case	75:		return "K"       
		case	76:		return "L"       
		case	77:		return "M"       
		case	78:		return "N"       
		case	79:		return "O"       
		case	80:		return "P"       
		case	81:		return "Q"       
		case	82:		return "R"       
		case	83:		return "S"       
		case	84:		return "T"       
		case	85:		return "U"       
		case	86:		return "V"       
		case	87:		return "W"       
		case	88:		return "X"       
		case	89:		return "Y"       
		case	90:		return "Z"       
		case	162:	return "L CTRL"		 
		case	163:	return "R CTRL"		 
		case	164:	return "L ALT"       
		case	165:	return "R ALT"       
		case	186:	return ";"
		case	222:	return "'"
		case	13:		return "Enter"
		case	220:	return	"\\"
		case	8:		return	"Backspace"
		case	219:	return "["
		case	221:	return "]"
		case	188:	return ","
		case	190:	return "."
		case	191:	return "/"
		case	16:		return "Shift"
		case	9:		return "Tab"
		case	192:	return "`"
		case	48:		return "0"
		case	49:		return "1"
		case	50:		return "2"
		case	51:		return "3"
		case	52:		return "4"
		case	53:		return "5"
		case	54:		return "6"
		case	55:		return "7"
		case	56:		return "8"
		case	57:		return "9"
		
		case	96:		return "Num 0"
		case	97:		return "Num 1"
		case	98:		return "Num 2"
		case	99:		return "Num 3"
		case	100:	return "Num 4"
		case	101:	return "Num 5"
		case	102:	return "Num 6"
		case	103:	return "Num 7"
		case	104:	return "Num 8"
		case	105:	return "Num 9"
		case	111:	return "Num /"
		case	106:	return "Num *"
		case	107:	return "Num +"
		case	110:	return "Num ."
		case	109:	return "Num -"
		
		case	112:	return "F1"
		case	113:	return "F2"
		case	114:	return "F3"
		case	115:	return "F4"
		case	116:	return "F5"
		case	117:	return "F6"
		case	118:	return "F7"
		case	119:	return "F8"
		case	120:	return "F9"
		case	121:	return "F10"
		case	122:	return "F11"
		case	123:	return "F12"
		case	145:	return "ScrLk"
		case	19:		return "Pause"
		case	20:		return "Caps Lock"
		case	189:	return "-"
		case	187:	return "="
		case	45:		return "Insert"
		case	36:		return "Home"
		case	33:		return "Page Up"
		case	34:		return "Page Down"
		case	35:		return "End"
		case	46:		return "Delete"
		case	144:	return "NumLock"
		case	38:		return "Up"
		case	40:		return "Down"
		case	37:		return "Left"
		case	39:		return "Right"
		case	91:		return "L Windows"
		case	92:		return "R Windows"
		case	32:		return "Space"
		case	0:		return " "
		case	179:	return "Play"
		case	173:	return "Mute"
		case	174:	return "Volume Down"
		case	175:	return "Volume Up"

		default:		return "key doesn't exist in this map"
	}
}

function collision_line_first(x1, y1, x2, y2, object, prec, notme){
	//CREDIT FOR THE FOLLOWING FUNCTION GOES TO XOT on gmslscripts.com!
	/// GMLscripts.com/license
    var ox = x1
	var oy = y2
    var dx = x2
    var dy = y2
    var sx = dx - ox;
    var sy = dy - oy;
    var inst = collision_line(ox,oy,dx,dy,object,prec,notme);
    if (inst != noone) {
        while ((abs(sx) >= 1) || (abs(sy) >= 1)) {
            sx /= 2;
            sy /= 2;
            var i = collision_line(ox,oy,dx,dy,object,prec,notme);
            if (i) {
                dx -= sx;
                dy -= sy;
                inst = i;
            } else {
                dx += sx;
                dy += sy;
            }
        }
    }
    return inst;
}
