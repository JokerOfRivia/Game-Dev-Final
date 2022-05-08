event_inherited();
if (state_machine.state == 1) {
	var dir_x = (target.x - x);
	var dir_y = (target.y - y);
	var distance = magnitude(dir_x, dir_y);
	var angle = darctan2(dir_y, dir_x);
	draw_line_color(x + 8*dcos(angle), y + 8*dsin(angle), target.x - 8*dcos(angle), target.y - 8*dsin(angle), c_red, c_red);
}

if (debug_mode) {
	draw_text(x, y+12, state_machine.state);
	draw_text(x, y+2, state_machine.substate);
	draw_text(x, y+22, state_machine.state_timer);
}
