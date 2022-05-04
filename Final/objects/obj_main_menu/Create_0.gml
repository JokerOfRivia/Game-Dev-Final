display_set_gui_size(320, 180);


function panel(x, y, width, height, elements) constructor {
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	
	self.elements = elements;
	
	self.highlighted = 0;
	
	static draw = function(){
		for (var i = 0; i < ds_list_size(elements); ++i) {
			var do_highlight = (i == highlighted)? true: false;
			elements[| i ].draw(do_highlight);
		}
	}
	static step = function(){
		for (var i = 0; i < ds_list_size(elements); ++i) {
			var do_highlight = (i == highlighted)? true: false;
			elements[| i ].step(do_highlight);
		}
		if(obj_virtual_controller.input_a_pressed) {
			elements[| highlighted ].on_press();
			obj_sound.play_sfx(sfx_button3);
		}
		else {
			if(obj_virtual_controller.input_down_pressed) {
				obj_sound.play_sfx(sfx_button2);
				highlighted = wrap(highlighted + 1, 0, ds_list_size(elements))
			}
			if(obj_virtual_controller.input_up_pressed) {
				obj_sound.play_sfx(sfx_button2);
				highlighted = wrap(highlighted - 1, 0, ds_list_size(elements))
			}
		}
	}
}
function menu_element(x, y, width, height, sprite) {
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	
	self.sprite_index = sprite;
	self.image_index = 0;
	
	static draw = function(highlighted){}
	static step = function(){}
	on_press = function(){}
}
function menu_button(x, y, width, height, sprite, text, callback, argument) : menu_element(x, y, width, height, sprite) constructor {
	
	self.text = text;
	
	self.callback = callback;
	self.argument = argument;
	
	on_press = function(){
		if (callback!=undefined) {
			if (self.argument!=undefined) callback(self.argument);
			else callback();
		}
	};
	
	static autofit = function(padding){
		draw_set_font(fnt_retropc);
		var text_width = string_width(text);
		var text_height = string_height(text);
		
		var new_width = text_width+padding*2;
		var new_height = text_height+padding*2;
		
		width = new_width;
		height = new_height;
	}
	
	static draw = function(highlighted){
		draw_set_font(fnt_retropc);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_sprite_stretched(self.sprite_index, self.image_index, self.x, self.y, width, height);
		if (highlighted) draw_set_color(c_yellow);
		draw_text(self.x + width/2, self.y + height/2, text);
		draw_set_color(c_white);
		
		self.image_index = wrap(self.image_index + 1, 0, sprite_get_number(self.sprite_index));
	};
}
function menu_slider(x, y, width, height, sprite, object, value, minval, maxval, callback) : menu_element(x, y, width, height, sprite) constructor {
	self.minval = minval;
	self.maxval = maxval;
	range = abs(maxval-minval);
	self.object = object;
	self.value = value;
	self.minval = minval;
	self.maxval = maxval;
	slidespeed = 0.2;
	self.callback = callback;
	
	static step = function(highlighted){
		var rawval = variable_instance_get(object, value);
		if (obj_virtual_controller.input_left_pressed) {
			variable_instance_set(object, value, clamp(rawval - slidespeed, minval, maxval)); 
			callback();
		}
		if (obj_virtual_controller.input_right_pressed) {
			variable_instance_set(object, value, clamp(rawval + slidespeed, minval, maxval)); 
			callback();
		}
	}
	static draw = function(highlighted){
		
		var rawval = variable_instance_get(object, value);
		var pos = (rawval - minval) / (range);

		draw_rectangle_color(x,y,x+width-1, y+height-1, c_dkgrey, c_dkgrey, c_dkgrey, c_dkgrey, false);
		var c = c_grey;
		if (highlighted) c = c_white; 
		draw_rectangle_color(x,y,x+(width*pos)-1, y+height, c, c, c, c, false);
		draw_sprite_stretched(self.sprite_index, self.image_index, self.x, self.y, width, height);
		
		self.image_index = wrap(self.image_index + 1, 0, sprite_get_number(self.sprite_index));
		
		draw_text(x+100, y+4, rawval);
	}
	
	on_press = function(){
		var rawval = variable_instance_get(object, value);
		var newval = (rawval == 0) ? 1.0: 0.0;
		variable_instance_set(object, value, newval);
		callback();
	}
}
active_panel = 0;

test_elements = ds_list_create();
options_elements = ds_list_create();

//main
ds_list_add(test_elements, new menu_button(32, 32, 40, 24, spr_debug_button, "START", room_goto, rm_1));
ds_list_add(test_elements, new menu_button(32, 64, 40, 24, spr_debug_button, "OPTIONS",  function(){active_panel = 1; obj_sound.play_sfx(sfx_button1);}, ));
ds_list_add(test_elements, new menu_button(32, 96, 40, 24, spr_debug_button, "QUIT", game_end,));
//options
ds_list_add(options_elements, new menu_button(48, 32, 40, 24, spr_debug_button, "Fullscreen", toggle_fullscreen,));
ds_list_add(options_elements, new menu_slider(48, 64, 64, 24, spr_debug_slider, obj_sound, "music_volume", 0, 1, obj_sound.update));
ds_list_add(options_elements, new menu_button(48, 96, 40, 24, spr_debug_button, "BACK", function(){active_panel = 0; obj_sound.play_sfx(sfx_button1);}, ));

panel_array = [new panel(16, 16, 200, 200, test_elements), new panel(16, 16, 200, 200, options_elements)];


