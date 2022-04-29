/*
	THERE IS SOME COMPLICATED STUFF GOING ON IN HERE!
	
	PLEASE REFER TO obj_actor, obj_solid, AND scr_statemachine TO UNDERSTAND!!
*/
event_inherited();
controller = obj_virtual_controller;

#region //gameplay vals
respawn_x = x;
respawn_y = y;
#endregion

#region //physics values
velocity_x = 0;
velocity_y = 0;
velocity_max = 20;

drag = 0.1;
grav = 5;
#endregion

function cancel_velocity_x(){
	velocity_x = 0;
}
function cancel_velocity_y(){
	velocity_y = 0;
}

#region //states
	//0
	function state_move(){
		var input_x = controller.input_raw_x;
		
		velocity_x = clamp(velocity_x+input_x, -velocity_max, velocity_max);
		
		velocity_x = lerp(velocity_x, 0, drag);	
		velocity_y += grav;
		
		
		move_x(velocity_x, cancel_velocity_x);
		move_y(velocity_y, cancel_velocity_y);
	}
	//1
	function state_respawn(){
		x = respawn_x;
		y = respawn_y;
	}
#endregion

state_machine = new StateMachine([state_move, state_respawn], id);
state_machine.state_change(0);
