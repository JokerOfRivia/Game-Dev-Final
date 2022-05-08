event_inherited();

take_knockback = function(knockback_x, knockback_y){
	if (i_frames_counter < 1) {
		velocity_x+=knockback_x;
		velocity_y+=knockback_y;
	}
}
attack = function(){
	state_machine.state_change(2, 0);
}
get_target = function(){
	var hit = collision_line(x-target_range, y+(sprite_height/2), x+target_range, y+(sprite_height/2), obj_player, false, false);
	if (hit!=noone) {
		target = hit;	
	}
}
chase = function(){
	if (target!=noone) {
		var dir = (target.x - x);
		if abs(dir) < 100 attack();
		velocity_x += (move_speed * sign(dir));
	}
} 

#region //gameplay values
hp_max = 1;
hp = hp_max;

explode_timer = 80;
explode_radius = 80;
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


#region //states
//0
function state_search(){
	if (!is_standing()) {
		state_machine.state_change(3);
	}
	
	velocity_x = lerp(velocity_x, 0, drag);	
	
	get_target();
	
	if (target!=noone) {
		state_machine.state_change(1);
	}
	
	//count down i frames from hit
	i_frames_counter = (i_frames_counter > 0 )? i_frames_counter-1 : 0;
	
	velocity_y += grav;
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);	
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
}

//1
function state_chase(){
	if (!is_standing()) {
		state_machine.state_change(3);
	}
	velocity_x = lerp(velocity_x, 0, drag);	
	
	chase();
	
	if (place_meeting(x, y, obj_enemy_example)) {
		velocity_x = -10;
	}
	else if (place_meeting(x + velocity_x, y, obj_enemy_example)) {
		velocity_x = lerp(velocity_x, velocity_x*-1, drag);
	}
	
	//count down i frames from hit
	i_frames_counter = (i_frames_counter > 0 )? i_frames_counter-1 : 0;
	
	velocity_y += grav;
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
}

//2
function state_die(){
	if (state_timer > explode_timer) {
		instance_create_explosion(x+sprite_width/2, y+sprite_height, explode_radius, 30, obj_actor, 2, 10);
		instance_destroy();
	}
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
	
	//count down i frames from hit
	i_frames_counter = (i_frames_counter > 0 )? i_frames_counter-1 : 0;
	
	velocity_y += grav;
}
//3
function state_air(){
	if (is_standing()){
		state_machine.state_change(0)
	}
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
	
	//count down i frames from hit
	i_frames_counter = (i_frames_counter > 0 )? i_frames_counter-1 : 0;
	
	velocity_y += grav;
}
#endregion

state_machine = new StateMachine([state_search, state_chase, state_die, state_air], id);
state_machine.state_change(0);
