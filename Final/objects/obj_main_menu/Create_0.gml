event_inherited();

main_elements = ds_list_create();
options_elements = ds_list_create();
keybind_elements = ds_list_create();
credits_elements = ds_list_create();

//main
ds_list_add(main_elements, new menu_button(32, 32, 40, 24, spr_debug_button, "START", room_goto, rm_1));
ds_list_add(main_elements, new menu_button(32, 64, 40, 24, spr_debug_button, "OPTIONS",  function(){active_panel = 1; obj_sound.play_sfx(sfx_button1);}, ));
ds_list_add(main_elements, new menu_button(32, 96, 40, 24, spr_debug_button, "QUIT", game_end,));

//options
ds_list_add(options_elements, new menu_button(48, 10, 40, 24, spr_debug_button, "Fullscreen", toggle_fullscreen,));
ds_list_add(options_elements, new menu_slider(48, 40, 80, 16, spr_debug_slider, obj_sound, "music_volume", 0, 1, obj_sound.update, "Music"));
ds_list_add(options_elements, new menu_slider(48, 70, 80, 16, spr_debug_slider, obj_sound, "sfx_volume", 0, 1, obj_sound.update, "SFX"));
ds_list_add(options_elements, new menu_button(48, 100, 40, 24, spr_debug_button, "KEYBINDS", function(){active_panel = 2; obj_sound.play_sfx(sfx_button1);}, ));
ds_list_add(options_elements, new menu_button(48, 130, 40, 24, spr_debug_button, "BACK", function(){active_panel = 0; obj_sound.play_sfx(sfx_button1);}, ));

//keybinds
ds_list_add(keybind_elements, new menu_button(32, 10, 40, 24, spr_debug_button, "BACK", function(){active_panel = 1; obj_sound.play_sfx(sfx_button1);}, ));
ds_list_add(keybind_elements, new menu_keybind(32, 40, 40, 24, spr_debug_button, obj_virtual_controller.up, "up"));
ds_list_add(keybind_elements, new menu_keybind(32, 70, 40, 24, spr_debug_button, obj_virtual_controller.left, "left"));
ds_list_add(keybind_elements, new menu_keybind(32, 100, 40, 24, spr_debug_button, obj_virtual_controller.jump, "jump"));
ds_list_add(keybind_elements, new menu_button(200, 10, 40, 24, spr_debug_button, "RESET", function(){obj_virtual_controller.reset_config(); obj_sound.play_sfx(sfx_button1);}, ));
ds_list_add(keybind_elements, new menu_keybind(200, 40, 40, 24, spr_debug_button, obj_virtual_controller.down, "down"));
ds_list_add(keybind_elements, new menu_keybind(200, 70, 40, 24, spr_debug_button, obj_virtual_controller.right, "right"));
ds_list_add(keybind_elements, new menu_keybind(200, 100, 40, 24, spr_debug_button, obj_virtual_controller.a, "a"));

//credits
ds_list_add(credits_elements, new menu_button(32, 10, 40, 24, spr_debug_button, "BACK", function(){active_panel = 1; obj_sound.play_sfx(sfx_button1);}, ));
ds_list_add(credits_elements, new menu_label(32, 32, room_width-32, room_height-32, spr_credits, ""));

panel_array = [new panel(16, 16, 200, 200, main_elements), new panel(16, 16, 200, 200, options_elements)
	, new panel(16, 16, 200, 200, keybind_elements), new panel(16, 16, 200, 200, credits_elements)];


