if (debug_mode) {
	draw_set_font(fnt_retropc);
	draw_text(x, y-30, state_machine.state_timer);
	draw_text(x, y-20, state_machine.state);
	draw_text(x, y-10, state_machine.substate);
}
if (i_frames_counter > 10) {
	shader_set(shd_flash);
}

sprite_subdex = clamp(sprite_subdex, 0, array_length(sprite_left_array)-1);

switch (sprite_subdex) {
	case 0:
		sprite_looping = false;
	break;
	case 1:
		sprite_looping = false;
	break;
	case 2:
		sprite_looping = false;
	break;
	case 3:
		sprite_looping = false;
	break;
	case 4:
		sprite_looping = false;
	break;
	case 5:
		sprite_looping = false;
	break;
	case 6:
		sprite_looping = true;
	break;
	case 7:
		sprite_looping = false;
	break;
	case 8:
		sprite_looping = true;
	break;
}

if (!sprite_looping) {
	image_index = clamp(image_index, 0, sprite_get_number(sprite_left_array[sprite_subdex])-1);
}

if (is_riding(obj_platform_horizontal)) {
	if (controller.facing_x == -1) {
	sprite_index = sprite_left_array[sprite_subdex];
	}
	else if (controller.facing_x == 1) {
		sprite_index = sprite_right_array[sprite_subdex];
	}
}
else if (facing_x == -1) {
	sprite_index = sprite_left_array[sprite_subdex];
}
else if (facing_x == 1) {
	sprite_index = sprite_right_array[sprite_subdex];
}
else if (controller.facing_x == -1) {
	sprite_index = sprite_left_array[sprite_subdex];
}
else if (controller.facing_x == 1) {
	sprite_index = sprite_right_array[sprite_subdex];
}

draw_self();

shader_reset();

