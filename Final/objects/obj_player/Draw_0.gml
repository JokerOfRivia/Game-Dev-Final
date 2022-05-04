draw_self()
if (debug_mode) {
	draw_set_font(fnt_retropc);
	draw_text(x, y-30, state_machine.state_timer);
	draw_text(x, y-20, state_machine.state);
	draw_text(x, y-10, state_machine.substate);
}
