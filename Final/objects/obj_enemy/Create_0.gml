event_inherited();
is_riding = function(solid_id){
	if (place_meeting(x, y+1, solid_id)){
		return true;
	}
	else return false;
}

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


//all enemies will inherit certain functions, but it's up to you to modify them in child objects
take_damage = function(amount){
	hp = max(0, hp-amount);
}
attack = function(){
	instance_create_hurtbox(64 * facing_x, 0, 64, 64, 120, id, obj_player, 0);
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

