event_inherited();
is_riding = function(solid_id){
	if (place_meeting(x, y+1, solid_id)){
		return true;
	}
	else return false;
}

#region //gameplay values
hp_max = 3;
hp = hp_max;

i_frames = 10;
i_frames_counter = -1;
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
default_squish_action = instance_destroy;

#region //ai
	target = noone;
	target_range = 24;
#endregion


//all enemies will inherit certain functions, but it's up to you to modify them in child objects
take_damage = function(amount){
	if (i_frames_counter < 1){
		obj_camera.do_screenshake(6, amount);
		hp -= amount;
	}
}
attack = function(){
	instance_create_hurtbox(8 * facing_x, 0, 8, 8, 10, id, obj_player, 0, 2*facing_x, -1);
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
		if abs(dir) < 12 attack();
		velocity_x += (move_speed * sign(dir));
	}
}

