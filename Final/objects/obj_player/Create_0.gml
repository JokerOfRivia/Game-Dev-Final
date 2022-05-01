/*
	THERE IS SOME COMPLICATED STUFF GOING ON IN HERE!
	
	PLEASE REFER TO obj_actor, obj_solid, AND scr_statemachine TO UNDERSTAND!!
*/
event_inherited();

is_riding = function(solid_id){
	if (place_meeting(x, y+1, solid_id) and solid_id.collidable){
		return true;
	}
	else return false;
}


controller = obj_virtual_controller;

#region //gameplay vals
respawn_x = x;
respawn_y = y;
#endregion

#region //physics values
velocity_x = 0;
velocity_y = 0;
velocity_max = 20;

//govern horizontal movement and gravity
move_speed = 1.5;
drag = 0.2;
grav = 1.5;

//these are used to track coyote time
coyote_max = 8;
coyote_frames = coyote_max;

//main jump-related variables
jump_accel = 5;
jump_max = 5;
peak_time = 10;
peak_grav_coef = 0.5;
#endregion

function cancel_velocity_x(){
	velocity_x = 0;
}
function cancel_velocity_y(){
	velocity_y = 0;
}

#region //states
	//0
	function state_run(){
		velocity_x = lerp(velocity_x, 0, drag);	
		var input_x = move_speed * controller.input_normal_x;
		velocity_x += input_x;
		velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
		
		velocity_y += grav;
		velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
		
		
		move_x(velocity_x, cancel_velocity_x);
		move_y(velocity_y, cancel_velocity_y);
		
		//jump button
		if (controller.input_start_pressed) {
			state_machine.state_change(1, 0);
		}
		
		//coyote time
		if (!is_standing()){
			if (coyote_frames > 0) {
			coyote_frames--;
			}
			else {
				coyote_frames = coyote_max;
				state_machine.state_change(1, 2);
			}
		}
		
	}
	//1
	function state_jump(){
		switch (state_machine.substate) {
			//going up
			case 0:
				if (controller.input_start_released or state_machine.state_timer == jump_max){
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
				velocity_y += grav*peak_grav_coef;
				
				//air strafing just borrows from state_run for now, probably should tune later
				velocity_x = lerp(velocity_x, 0, drag);	
				var input_x = move_speed * controller.input_normal_x;
				velocity_x += input_x;	
			break;
			
			//landing
			case 2:
				if (is_standing()){
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
	}
	//2 (this is mostly a filler for now)
	function state_respawn(){
		x = respawn_x;
		y = respawn_y;
	}
#endregion

state_machine = new StateMachine([state_run, state_jump, state_respawn], id);
state_machine.state_change(0);
