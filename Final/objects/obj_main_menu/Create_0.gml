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
		
		self.image_index = wrap(self.image_index + 1, 0, sprite_get_number(self.sprite_index))
	};
}

active_panel = 0;

test_elements = ds_list_create();
options_elements = ds_list_create();

//main
ds_list_add(test_elements, new menu_button(32, 32, 40, 24, spr_debug_button, "START", room_goto, rm_1));
ds_list_add(test_elements, new menu_button(32, 64, 40, 24, spr_debug_button, "OPTIONS",  function(){active_panel = 1; obj_sound.play_sfx(sfx_button1);}, ));
ds_list_add(test_elements, new menu_button(32, 96, 40, 24, spr_debug_button, "QUIT", game_end,));
//options
ds_list_add(options_elements, new menu_button(32, 32, 40, 24, spr_debug_button, "Fullscreen", toggle_fullscreen,));
ds_list_add(options_elements, new menu_button(32, 64, 40, 24, spr_debug_button, "Toggle Music", function(){
	if (obj_sound.music_volume == 0.0) obj_sound.set_music_volume(1); else obj_sound.set_music_volume(0);
	},));
ds_list_add(options_elements, new menu_button(32, 96, 40, 24, spr_debug_button, "BACK", function(){active_panel = 0; obj_sound.play_sfx(sfx_button1);}, ));

panel_array = [new panel(16, 16, 200, 200, test_elements), new panel(16, 16, 200, 200, options_elements)];


