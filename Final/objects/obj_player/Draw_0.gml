draw_self()
if (debug_mode) {
	draw_text(x, y-100, state_machine.state);
	draw_text(x+20, y-100, is_riding(obj_solid));
}
