if (i_frames_counter > 1) {
	shader_set(shd_flash);
}

if (facing_x = 1) {
	switch(state_machine.state) {
	case 0:
		sprite_index = sprite_walk_right;
	break
	
	case 1:
		sprite_index = sprite_attack_right;
	break;
	
	case 2:
		sprite_index = sprite_idle;
	break;
	}
}
else {
	switch(state_machine.state) {
	case 0:
		sprite_index = sprite_walk_left;
	break
	
	case 1:
		sprite_index = sprite_attack_left;
	break;
	
	case 2:
		sprite_index = sprite_idle;
	break;
	}
}
draw_self();
shader_reset();
