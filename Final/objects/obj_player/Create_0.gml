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

grav = 5;
#endregion

#region //states
	//0
	function state_move(){
		var input_x = controller.input_normal_x;
		velocity_x = clamp(velocity_x+input_x, -velocity_max, velocity_max);
		
		velocity_y += grav;
		
		move_x(velocity_x, default_move_action);
		move_y(velocity_y, default_move_action);
	}
	//1
	function state_respawn(){
		x = respawn_x;
		y = respawn_y;
	}

#endregion

state_machine = new StateMachine([state_move, state_respawn], id);
