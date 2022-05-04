event_inherited();

main_elements = ds_list_create();
options_elements = ds_list_create();
keybind_elements = ds_list_create();

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
ds_list_add(keybind_elements, new menu_button(48, 32, 40, 24, spr_debug_button, "BACK", function(){active_panel = 1; obj_sound.play_sfx(sfx_button1);}, ));


panel_array = [new panel(16, 16, 200, 200, main_elements), new panel(16, 16, 200, 200, options_elements)
	, new panel(16, 16, 200, 200, keybind_elements)];


