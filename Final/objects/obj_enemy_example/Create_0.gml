event_inherited();

#region //gameplay values
hp = 3;
base_knockback = 10;
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
	if (state_machine.state_timer mod 60 == 0) instance_create_hurtbox(8 * facing_x, 0, 8, 8, 8, id, obj_player, 1, base_knockback * facing_x, -0.5 * base_knockback);
}
take_knockback = function(knockback_x, knockback_y){
	if (i_frames_counter < 1) {
		velocity_x+=knockback_x;
		velocity_y+=knockback_y;
	}
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
	instance_destroy();
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
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
