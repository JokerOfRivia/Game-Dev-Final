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
		if(obj_virtual_controller.input_a_pressed) {
			elements[| highlighted ].on_press();
		}
		else {
			if(obj_virtual_controller.input_down_pressed) {
				highlighted = wrap(highlighted + 1, 0, ds_list_size(elements))
			}
			if(obj_virtual_controller.input_up_pressed) {
				highlighted = wrap(highlighted - 1, 0, ds_list_size(elements))
			}
		}
	}
}

function menu_button(x, y, width, height, sprite, text, callback, argument) constructor {
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	
	self.sprite_index = sprite;
	self.image_index = 0;
	
	self.text = text;
	
	self.callback = callback;
	self.argument = argument;
	
	on_press = function(){
		callback(self.argument);
	};
	
	static autofit = function(padding){
		draw_set_font(fnt_pixelarribig);
		var text_width = string_width(text);
		var text_height = string_height(text);
		
		var new_width = text_width+padding*2;
		var new_height = text_height+padding*2;
		
		width = new_width;
		height = new_height;
	}
	
	static draw = function(highlighted){
		draw_set_font(fnt_pixelarribig);
		draw_set_halign(fa_center);
		draw_sprite_stretched(self.sprite_index, self.image_index, self.x, self.y, width, height);
		if (highlighted) draw_set_color(c_yellow);
		draw_text(self.x + width/2, self.y + height/2, text);
		draw_set_color(c_white);
		
		self.image_index = wrap(self.image_index + 1, 0, sprite_get_number(self.sprite_index))
	};
}

function callback_test() {
	game_end();
}
function callback_test2() {
	show_message("test 2");
}

test_elements = ds_list_create();
ds_list_add(test_elements, new menu_button(300, 300, 200, 200, spr_debug_red, "QUIT", callback_test,));
ds_list_add(test_elements, new menu_button(300, 400, 200, 200, spr_debug_red, "START", room_goto, rm_1));

for (var i = 0; i < 2; ++i) {
    test_elements[| i].autofit(20);
}

test_panel = new panel(300, 300, 200, 200, test_elements);
