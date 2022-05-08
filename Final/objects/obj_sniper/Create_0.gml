event_inherited();

#region //gameplay values
hp_max = 2;
hp = hp_max;

i_frames = 10;
i_frames_counter = -1;
#endregion

#region //physics values
velocity_x = 0;
velocity_y = 0;
velocity_max = 20;

//govern horizontal movement and gravity
move_speed = 0.8;
drag = 0.4;
grav = 1.5;

//gun
bullet_speed = 10;
bullet_damage = 1;
bullet_knockback = 3;
#endregion

#region //ai
	target = noone;
	target_range = 200;
	maintain_distance = 64;
	search_timer = 20;
#endregion

take_knockback = function(knockback_x, knockback_y){
	if (i_frames_counter < 1) {
		velocity_x+=knockback_x;
		velocity_y+=knockback_y;
	}
}
attack = function(angle){
	instance_create_bullet(x + 8*dcos(angle), y + 8*dsin(angle), angle, bullet_speed, 1, obj_player, bullet_damage, bullet_knockback);
}
get_target = function(){
	var hit = ds_list_create()
	collision_line_list(x, y, obj_player.x, obj_player.y, obj_actorsolid, true, true, hit, true);
	if (hit[| 0]==obj_player) {
		target = hit;
	}
	ds_list_destroy(hit);
}
chase = function(){
	if (target!=noone) {	
		var dir_x = (target.x - x);
		var dir_y = (target.y - y);
		var distance = magnitude(dir_x, dir_y);
		var angle = darctan2(dir_y, dir_x);
		
		if target = collision_line_first(x, y, target.x, target.y, obj_actorsolid, false, true) {
			attack(angle);
		}
		else state_machine.state_change(2);
	}
}

function move_and_iframes(){
	//count down i frames from hit
	i_frames_counter = (i_frames_counter > 0 )? i_frames_counter-1 : 0;
	
	velocity_y += grav;
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);	
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
}
#region //states
//0
function state_search(){
	if (!is_standing()) {
		state_machine.state_change(4);
	}
	
	velocity_x = lerp(velocity_x, 0, drag);	
	
	get_target();
	
	if (target!=noone) {
		state_machine.state_change(1);
	}
	move_and_iframes();
}

//1
function state_fire() {
	if (!is_standing()) {
		state_machine.state_change(4);
	}
	velocity_x = lerp(velocity_x, 0, drag);	
	
	chase();
	
	move_and_iframes();
}

//2
function state_chase(){
	if (!is_standing()) {
		state_machine.state_change(4);
	}
	velocity_x = lerp(velocity_x, 0, drag);	
	
	if (state_machine.state_timer < search_timer) {
		velocity_x = move_speed * sign(target.x - x);
	}
	else {
		target = noone;
		state_machine.state_change(0);
	}
	
	move_and_iframes();
}

//3
function state_die(){
	instance_destroy();
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
}
//4
function state_air(){
	if (is_standing()){
		state_machine.state_change(0)
	}
	move_and_iframes();
}
#endregion
state_machine = new StateMachine([state_search, state_fire, state_chase, state_die, state_air], id);
state_machine.state_change(0);
