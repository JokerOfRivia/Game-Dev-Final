event_inherited();

#region //gameplay values
hp = 3;
#endregion

#region //physics values

#endregion

#region //ai
target_range = 500;
#endregion

take_damage = function(amount){
	hp = max(0, hp-amount);
}
attack = function(){
	instance_create_hurtbox(64 * facing_x, 0, 64, 64, 10, id, obj_player, 0);
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
