event_inherited();

take_knockback = function(knockback_x, knockback_y){
	if (i_frames_counter < 1) {
		velocity_x+=knockback_x;
		velocity_y+=knockback_y;
	}
}


#region //gameplay values
hp_max = 1;
hp = hp_max;
#endregion

#region //physics values
velocity_x = 0;
velocity_y = 0;
velocity_max = 20;

//govern horizontal movement and gravity
move_speed = 2;
drag = 0.4;
grav = 1.5;
#endregion


