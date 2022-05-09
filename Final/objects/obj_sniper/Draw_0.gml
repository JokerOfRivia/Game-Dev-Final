event_inherited();
if (state_machine.state == 1) {
	var target_center_x = (target.x + target.sprite_width/2);
	var center_x = (x + sprite_width/2);
		
	var target_center_y = (target.y + target.sprite_height/2);
	var center_y = (y + sprite_height/2) - 4;
		
	var angle = point_direction(center_x, center_y, target_center_x, target_center_y);
		
	draw_set_alpha(random_range(0.1, 0.5));
	draw_line_color(center_x, center_y, target_center_x, target_center_y, c_red, c_red);
	draw_set_alpha(1);
	
	if (debug_mode) {
		draw_text(x, y+12, object_get_name(target));
	}
}
