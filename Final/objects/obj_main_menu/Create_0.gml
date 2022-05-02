function panel(x, y, width, height, elements) constructor {
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	
	self.active = true;
	
	self.elements = elements;
	
	self.highlighted = 0;
	
	static draw = function(){
		for (var i = 0; i < ds_list_size(elements); ++i) {
			var do_highlight = (i == highlighted)? true: false;
			elements[| i ].draw(do_highlight);
		}
	}
	static step = function(){
		var controller = obj_virtual_controller;
		if(controller.input_a_pressed) {
			elements[| highlighted ].on_press();
		}
		else {
			if(controller.input_down_pressed) {
				highlighted = wrap(highlighted + 1, 0, ds_list_size(elements))
			}
			if(controller.input_up_pressed) {
				highlighted = wrap(highlighted - 1, 0, ds_list_size(elements))
			}
		}
	}
}

function menu_button(x, y, width, height, sprite, text, callback) constructor {
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	
	self.sprite_index = sprite;
	self.image_index = 0;
	
	self.text = text;
	
	self.callback = callback;
	
	on_press = function(){
		callback();
	};
	
	static draw = function(highlighted){
		draw_set_font(fnt_pixelarribig);
		draw_sprite_stretched(self.sprite_index, self.image_index, self.x, self.y, width, height);
		if (highlighted) draw_set_color(c_yellow);
		draw_text(self.x, self.y, text);
		draw_set_color(c_white);
		
		self.image_index = wrap(self.image_index + 1, 0, sprite_get_number(self.sprite_index))
	};
}

function callback_test() {
	show_message("test");
}
function callback_test2() {
	show_message("test 2");
}

test_elements = ds_list_create();
ds_list_add(test_elements, new menu_button(300, 300, 200, 200, spr_debug_red, "test", callback_test));
ds_list_add(test_elements, new menu_button(300, 400, 200, 200, spr_debug_red, "test", callback_test2));
test_panel = new panel(300, 300, 200, 200, test_elements);
