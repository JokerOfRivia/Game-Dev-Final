display_set_gui_size(320, 180);

panel_array = [];
active_panel = 0;

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
				var n = 1;
				highlighted = wrap(highlighted + n, 0, ds_list_size(elements))
			}
			if(obj_virtual_controller.input_up_pressed) {
				obj_sound.play_sfx(sfx_button2);
				var n = -1;
				highlighted = wrap(highlighted + n, 0, ds_list_size(elements))
			}
		}
	}
}
function menu_element(x, y, width, height, sprite) {
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	is_label = false;
	self.sprite_index = sprite;
	self.image_index = 0;
	
	static draw = function(highlighted){}
	static step = function(){}
	on_press = function(){}
}
function menu_label(x, y, width, height, sprite, text) : menu_element(x, y, width, height, sprite) constructor {
	self.text = text;
	self.is_label = true;
	
	static draw = function(highlighted){
		draw_set_font(fnt_retropc);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_sprite_stretched(self.sprite_index, self.image_index, self.x, self.y, width, height);
		draw_set_color(c_white);
		draw_text(self.x + width/2, self.y + height/2, text);
		
		self.image_index = wrap(self.image_index + 1, 0, sprite_get_number(self.sprite_index));
	}
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
function menu_slider(x, y, width, height, sprite, object, value, minval, maxval, callback, label) : menu_element(x, y, width, height, sprite) constructor {
	self.minval = minval;
	self.maxval = maxval;
	range = abs(maxval-minval);
	self.object = object;
	self.value = value;
	self.minval = minval;
	self.maxval = maxval;
	slidespeed = 0.2;
	self.callback = callback;
	self.text = label;
	
	static step = function(highlighted){
		if (highlighted) {
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
		
		draw_text(x+width*2, y+4, text + ": " + string(rawval));
	}
	
	on_press = function(){
		var rawval = variable_instance_get(object, value);
		var newval = (rawval == 0) ? 1.0: 0.0;
		variable_instance_set(object, value, newval);
		callback();
	}
}
