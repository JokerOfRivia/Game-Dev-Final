event_inherited();
is_riding = is_standing;

#region //physics values
velocity_x = 0;
velocity_y = 0;
velocity_max = 20;

//govern horizontal movement and gravity
move_speed = 1.5;
drag = 0.25;
grav = 1.5;
#endregion

#region //states
function state_die(){
	instance_destroy();
}
#endregion

state_machine = new StateMachine([state_die], id);
