/*
	obj_hud is a convenient, memory-efficient way of displaying HUD elements.
	
	The concept is this: many basic types of HUD objects are predefined here. If you
	need a counter for score, coins, or lives, you could make *all* of them with
	hud_counter.
	
	Each HUD element has a "draw" function that the obj_hud executes during its own GUI event.
*/
elements = ds_list_create();

function hud_element(x, y, sprite) constructor {
	self.x = x;
	self.y = y;
	sprite_index = sprite;
	image_index = 0;
	image_index_max = sprite_get_number(sprite_index)-1;
	
	static draw = function() {
		draw_sprite(sprite_index, image_index, x, y);
		
		image_index = wrap(image_index+1, 0, image_index_max);
	}
}

function hud_piece_counter(x, y, sprite, separation, object, variable_name, is_vertical, empty_sprite, secondary_variable) : hud_element(x, y, sprite) constructor {
	self.separation = separation;
	self.object = object
	value = variable_name;
	self.vertical = is_vertical;
	self.sprite_index_empty = empty_sprite;
	self.compare = secondary_variable;
	
	static draw = function() {
		if (!instance_exists(object)) {
				exit;
		}
		
		var val = round(variable_instance_get(object, value));
		
		var offset = 0;
		
		if(sprite_index_empty==undefined or compare==undefined) {
			for (var i = 0; i < val; ++i) {
			    draw_sprite(sprite_index, image_index, x + offset*!vertical, y + offset*vertical);
				offset+=separation+sprite_get_width(sprite_index);
			}
		}
		else {
			var maximum = variable_instance_get(object, compare);
			var difference = maximum-val;
			for (var i = 0; i < val; ++i) {
			    draw_sprite(sprite_index, image_index, x + offset*!vertical, y + offset*vertical);
				offset+=separation+sprite_get_width(sprite_index);
			}
			for (var i = 0; i < difference; ++i) {
				draw_sprite(sprite_index_empty, image_index, x + offset*!vertical, y + offset*vertical);
				offset+=separation+sprite_get_width(sprite_index_empty);
			}
		}
		
		image_index = wrap(image_index+1, 0, image_index_max);
	}
}

function hud_counter(x, y, sprite, text_color, object, variable_name, digits_drawn) : hud_element(x, y, sprite) constructor {
		self.text_color = text_color;
		self.object = object;
		value = variable_name;
		self.digits_drawn = digits_drawn;
		
		static draw = function() {
			if (!instance_exists(object)) {
				exit;
			}
			
			var val = string_replace_all(string_format(variable_instance_get(object, value), digits_drawn, 0), " ", "0");
			
			draw_sprite(sprite_index, image_index, x, y);
			draw_text_color(x, y, val, text_color, text_color, text_color, text_color, 1);
			
			image_index = wrap(image_index+1, 0, image_index_max);
		}
}

function add_element(type, arguments) {
	switch (type){
		case "element":
		ds_list_add(elements, new hud_element(arguments[0], arguments[1], arguments[2]));
		break;
		case "hud_counter":
		ds_list_add(elements, new hud_counter(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6]));
		break;
		case "hud_piece_counter":
		ds_list_add(elements, new hud_piece_counter(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5],  arguments[6], arguments[7], arguments[8]));
		break;
	}
}

function initialize_debug_hud(){
	add_element("hud_piece_counter", [4, 4, spr_debug_hud, 8, obj_player, "hp", false, spr_debug_hud2, "hp_max"]);
}

initialize_debug_hud();
