event_inherited();

#region //sprites
sprite_right = spr_sniper_left;
sprite_left = spr_sniper_right;
#endregion

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
bullet_speed = 5;
bullet_damage = 1;
bullet_knockback = 3;
reload_time = 80;
#endregion

#region //ai
	target = noone;
	target_range = 200;
	maintain_distance = 64;
	search_timer = 80;
#endregion

take_knockback = function(knockback_x, knockback_y){
	if (i_frames_counter < 1) {
		velocity_x+=knockback_x/2;
		velocity_y+=knockback_y/2;
	}
}

attack = function(angle) {
	var center_x = (x + sprite_width/2);
	var center_y = (y + sprite_height/2) - 6;
	
	instance_create_bullet(center_x, center_y, angle, bullet_speed, 1, target, bullet_damage, bullet_knockback);
}

get_target = function() {
	if (!collision_line(x, y, obj_player.x, obj_player.y, obj_solid, false, false)) {
		target = obj_player;
	}
}

chase = function() {
	if (target!=noone) {
		var target_center_x = (target.x + target.sprite_width/2);
		var center_x = (x + sprite_width/2);
		
		var target_center_y = (target.y + target.sprite_height/2);
		var center_y = (y + sprite_height/2) - 4;
		
		var angle = point_direction(center_x, center_y, target_center_x, target_center_y);
		
		facing_x = sign(target_center_x - center_x);
		
		if (!collision_line(center_x, center_y, target_center_x, target_center_y, obj_solid, false, false)) {
			if ((state_machine.state_timer mod reload_time == 0) or state_machine.state_timer == reload_time/10) {
				attack(angle);
			}
		}
		else state_machine.state_change(2);
	}
}
take_damage = function(amount){
	if (i_frames_counter < 1) {
		obj_camera.do_screenshake(10,1);
		obj_sound.play_sfx(sfx_hit);
		hp = clamp(hp-1, 0, hp_max);
		if (hp==0){
			state_machine.state_change(3);
		}
		i_frames_counter = i_frames;
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
		if (!collision_line(x, y, target.x, target.y, obj_solid, false, false)) {
			state_machine.state_change(1);
		}
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
	var drop = instance_create_layer(x, y, layer, obj_health_pickup);
	drop.velocity_x = velocity_x;
	drop.velocity_y = velocity_y;
	
	instance_destroy();
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
	
	move_and_iframes();
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
