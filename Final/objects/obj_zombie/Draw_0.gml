switch (state_machine.state) {
	case 0:
	if (facing_x = -1) {
		if (velocity_x = 0) sprite_index = spr_idle_left;
		else sprite_index = spr_walk_right;;
	}
	else {
		if (velocity_x = 0) sprite_index = spr_idle_right;
		else sprite_index = spr_walk_right;
	}
	
	case 2:
		if (facing_x = -1) sprite_index = spr_explode_left;
		else sprite_index = spr_explode_right;
		image_index = clamp(image_index, 0, sprite_get_number(spr_explode_right));
	break;
	
	default:
	if (facing_x = -1) sprite_index = spr_idle_left;
	else sprite_index = spr_idle_right;
}
event_inherited();
