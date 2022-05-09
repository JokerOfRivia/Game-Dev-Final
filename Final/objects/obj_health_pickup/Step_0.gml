velocity_x = lerp(velocity_x, 0, drag);
velocity_y += grav;

move_x(velocity_x, default_move_action);
move_y(velocity_y, default_move_action);

if place_meeting(x, y, obj_player) {
	obj_player.hp = clamp(obj_player.hp + 1, 0, obj_player.hp_max);
	instance_destroy();
}
