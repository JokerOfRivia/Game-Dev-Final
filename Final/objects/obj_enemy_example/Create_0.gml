event_inherited();

#region //gameplay values
hp = 3;
#endregion

#region //physics values
move_speed = 0.3;
#endregion

#region //ai
target_range = 100;
#endregion

take_damage = function(amount){
	if (i_frames_counter < 1) {
		obj_camera.do_screenshake(10,1);
		hp = clamp(hp-1, 0, hp_max);
		if (hp==0){
			state_machine.state_change(2);
		}
		i_frames_counter = i_frames;
	}
}
attack = function(){
	instance_create_hurtbox(8 * facing_x, 0, 8, 8, 8, id, obj_player, 1);
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

#region //states
//0
function state_search(){
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
	velocity_x = lerp(velocity_x, 0, drag);	
	
	chase();
	
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
	instance_destroy();
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
}
#endregion

state_machine = new StateMachine([state_search, state_chase, state_die], id);
state_machine.state_change(0);
