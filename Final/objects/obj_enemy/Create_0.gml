event_inherited();
is_riding = is_standing;

#region //gameplay values
hp = 3;
#endregion

#region //physics values
velocity_x = 0;
velocity_y = 0;
velocity_max = 20;

//govern horizontal movement and gravity
move_speed = 1;
drag = 0.4;
grav = 1.5;
#endregion

function cancel_velocity_x(){
	velocity_x = 0;
}
function cancel_velocity_y(){
	velocity_y = 0;
}

#region //ai
	target = noone;
	target_range = 150;
#endregion

#region //states
//0
function state_search(){
	var hit = collision_line(x-target_range, y, x+target_range, y, obj_player, false, false);
	if (hit!=noone) {
		target = hit;
		state_machine.state_change(1);
	}
	
	velocity_y += grav;
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);	
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
}

//1
function state_chase(){
	velocity_x = lerp(velocity_x, 0, drag);	
	
	if (target!=noone) {
		var dir = sign(target.x - x);
		
		velocity_x += (move_speed * dir);
	}
	
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
