/*
	obj_hud is a convenient, memory-efficient way of displaying HUD elements.
	
	The concept is this: many basic types of HUD objects are predefined here. If you
	need a counter for score, coins, or lives, you could make *all* of them with
	hud_counter.
	
	Each HUD element has a "draw" function that the obj_hud executs during its own GUI event.
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
		ds_list_add(elements, new hud_counter(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6],));
		break;
	}
}