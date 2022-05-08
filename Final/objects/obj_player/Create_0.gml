/*
	THERE IS SOME COMPLICATED STUFF GOING ON IN HERE!
	
	PLEASE REFER TO obj_actor, obj_solid, AND scr_statemachine TO UNDERSTAND!!
*/
event_inherited();

is_riding = function(solid_id){
	if (place_meeting(x, y+1, solid_id)){
		return true;
	}
	else return false
}


controller = obj_virtual_controller;

#region sprites
sprite_default = spr_player;
//left
sprite_air_attack = spr_player_air_attack_left;
sprite_fall_left = spr_player_fall_left;
sprite_ground_attack_left = spr_player_ground_attack_left;
sprite_hit_left = spr_player_hit_left;
sprite_jump_left = spr_player_jump_left;

/*right
sprite_air_attack = spr_player_air_attack_right;
sprite_fall_right = spr_player_fall_right;
sprite_ground_attack_right = spr_player_ground_attack_right;
sprite_hit_right = spr_player_hit_right;
sprite_jump_right = spr_player_jump_right;
*/
#endregion

#region //gameplay vals
hp_max = 3;
hp = hp_max;

base_damage = 1;
base_knockback = 8;
cancel_buffer = 5;
input_window = 15;

respawn_x = x;
respawn_y = y;

hp_max = 3;
hp = hp_max;

i_frames = 20;
i_frames_counter = -1;
#endregion

function take_damage(amount){
	if (i_frames_counter < 1 and state_machine.state!=4) {
		obj_camera.do_screenshake(5, amount);
		
		hp = clamp(hp-amount, 0, hp_max);
		
		if(hp==0) {
			state_machine.state_change(4);
		}
		
		i_frames_counter = i_frames;
	}
}

function take_knockback(knockback_x, knockback_y){
	if (i_frames_counter < 1) {
		velocity_x += knockback_x;
		velocity_y += knockback_y;
	}
}

function attack(version){
	var attack_origin = (controller.facing_x == 1)? sprite_width: 0;
	switch version {
		case 0:
			instance_create_hurtbox(attack_origin, -1, controller.facing_x * 16, 13, cancel_buffer, id, obj_enemy, base_damage, controller.facing_x*12, -4);
			velocity_x += controller.facing_x * move_speed * 10;
		break;
		case 1:
			instance_create_hurtbox(attack_origin, 0, controller.facing_x * 24, 13, cancel_buffer, id, obj_enemy, base_damage, controller.facing_x*12, -4);
			velocity_x += controller.facing_x * move_speed * 10;
		break;
		case 2:
			instance_create_hurtbox(attack_origin, 1, controller.facing_x * 26, 12, cancel_buffer, id, obj_enemy, base_damage, controller.facing_x*base_knockback, -base_knockback/2);
			velocity_x += controller.facing_x * move_speed * 10;
		break;
		case 3:
			instance_create_hurtbox(attack_origin, 2, controller.facing_x * 16, 26, cancel_buffer, id, obj_enemy, base_damage, controller.facing_x*base_knockback, -base_knockback/2);
			velocity_y -= jump_boost;
		break;
	}
}

#region //physics values
velocity_x = 0;
velocity_y = 0;
velocity_max = 20;

//govern horizontal movement and gravity
move_speed = 0.8;
drag = 0.25;
grav = 1.2;

//these are used to track coyote time
coyote_max = 5;
coyote_frames = coyote_max;

//main jump-related variables
jump_boost = 2.5;
jump_accel = 2.0;
jump_max = 6;
peak_time = 6;
peak_grav_coef = 0.5;
#endregion

function cancel_velocity_x(){
	velocity_x = 0;
}
function cancel_velocity_y(){
	velocity_y = 0;
}
default_squish_action = function(){
	state_machine.state_change(4);
}

#region //states
	//0
	function state_run(){
		velocity_x = lerp(velocity_x, 0, drag);	
		var input_x = move_speed * controller.input_normal_x;
		velocity_x += input_x;
		
		//jump button
		if (controller.input_jump_pressed) {
			velocity_y = max(velocity_y, 0);
			state_machine.state_change(1, 0);
		}
		
		//coyote time
		if (!is_standing()){
			
			if (coyote_frames > 0) {
				coyote_frames--;
			}
			else {
				state_machine.state_change(1, 2);
			}
		}
		else if (controller.input_a_pressed) {
			state_machine.state_change(3, 0);
		}
		
		velocity_y += grav;
		
		//apply velocity
		velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
		velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
		
		move_x(velocity_x, cancel_velocity_x);
		move_y(velocity_y, cancel_velocity_y);
		
		//sound stuff
		if(is_standing() and input_x!=0 and (state_machine.state_timer mod 8) == 0) obj_sound.play_sfx(sfx_footsteps);
	
		//count down i frames from hit
		i_frames_counter = (i_frames_counter > 0 )? i_frames_counter-1 : -1;
	}
	//1
	function state_jump(){
		switch (state_machine.substate) {
			//going up
			case 0:
				if (state_machine.state_timer < 1) {
					velocity_y = -jump_boost;
				}
				if (controller.input_jump_released or state_machine.state_timer == jump_max){
					state_machine.substate = 1;
				}
				velocity_y -= jump_accel;
				velocity_y += grav;
				
				//air strafing just borrows from state_run for now, probably should tune later
				velocity_x = lerp(velocity_x, 0, drag);	
				var input_x = move_speed * controller.input_normal_x;
				velocity_x += input_x;	
			break;
			
			//peak
			case 1:
				if (state_machine.state_timer == jump_max+peak_time) {
					state_machine.substate = 2;
				}
				if (is_standing()) state_machine.state_change(0);
				
				//apply reduced gravity
				velocity_y += grav*peak_grav_coef;
				
				//air strafing just borrows from state_run for now, probably should tune later
				velocity_x = lerp(velocity_x, 0, drag);	
				var input_x = move_speed * controller.input_normal_x;
				velocity_x += input_x;	
			break;
			
			//landing
			case 2:
				if (is_standing() or is_riding(obj_solid)){
					coyote_frames = coyote_max;
					state_machine.state_change(0);
				}
			
				velocity_y += grav;
				
				//air strafing just borrows from state_run for now, probably should tune later
				velocity_x = lerp(velocity_x, 0, drag);	
				var input_x = move_speed * controller.input_normal_x;
				velocity_x += input_x;	
			break;
		}
		
		velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
		velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
		
		move_x(velocity_x, cancel_velocity_x);
		move_y(velocity_y, cancel_velocity_y);
		
		//count down i frames from hit
		i_frames_counter = (i_frames_counter > 0 ? i_frames_counter-1 : -1);
	}
	//2 (this is mostly a filler for now)
	function state_respawn(){
		x = respawn_x;
		y = respawn_y;
		
		hp = hp_max;
		i_frames_counter = 0;
		velocity_x = 0;
		velocity_y = 0;
		
		if (state_machine.state_timer > 50) {
			state_machine.state_change(0);
		}
	}
	//3
	function state_ground_attack(){
		velocity_x = lerp(velocity_x, 0, drag);			
		velocity_y += grav;
		
		//apply velocity
		velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
		velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
		
		move_x(velocity_x, cancel_velocity_x);
		move_y(velocity_y, cancel_velocity_y);
		
		var can_combo = ((state_machine.state_timer > cancel_buffer) 
			and (state_machine.state_timer < input_window));
		
		switch state_machine.substate {
			case 0:
				if (state_machine.state_timer < 2) {
					attack(0);
				}
				else if (can_combo and controller.input_a_pressed) {
					state_machine.state_change(3, 1);
				}
			break;
			case 1:
				if (state_machine.state_timer < 2) {
					attack(1);
				}
				else if (can_combo and controller.input_a_pressed) {
					state_machine.state_change(3, 2);
				}
			break;
			case 2:
				if (state_machine.state_timer < 2) {
					attack(2);		
				}
			break;
		}
		if(state_machine.state_timer > input_window) state_machine.state_change(0);
		//count down i frames from hit
		i_frames_counter = (i_frames_counter > 0 ? i_frames_counter-1 : -1);
	}
	//4
	function state_die(){
		if (state_machine.state_timer > 60) {
			state_machine.state_change(2);
		}
		i_frames_counter = 2;
	}
#endregion

state_machine = new StateMachine([state_run, state_jump, state_respawn, state_ground_attack, state_die], id);
state_machine.state_change(0);
