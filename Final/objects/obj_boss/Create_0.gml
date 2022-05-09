event_inherited();
hitbox = obj_boss_hitbox;

is_riding = function(solid_id){
	if (place_meeting(x, y+1, solid_id)){
		return true;
	}
	else return false;
}

#region //sprites
sprite_attack_left = spr_finalboss_atk_left;
sprite_attack_right = spr_finalboss_atk_right;
sprite_idle = spr_finalboss_idle;
sprite_walk_left = spr_finalboss_walk_left;
sprite_walk_right = spr_finalboss_walk_right;
#endregion

#region //gameplay values
hp_max = 10;
hp = hp_max;

i_frames = 15;
i_frames_counter = -1;
#endregion

#region //physics values
velocity_x = 0;
velocity_y = 0;
velocity_max = 20;

//govern horizontal movement and gravity
move_speed = 1;
drag = 0.5;
grav = 2;
#endregion

function cancel_velocity_x(){
	velocity_x = 0;
}
function cancel_velocity_y(){
	velocity_y = 0;
}
default_squish_action = instance_destroy;

#region //ai
	target = obj_player;
#endregion


//all enemies will inherit certain functions, but it's up to you to modify them in child objects
take_damage = function(amount){
	if (i_frames_counter < 1 and state_machine.state!=2){
		i_frames_counter = i_frames;
		obj_camera.do_screenshake(12, amount);
		hp -= amount;
		if (hp < 1) state_machine.state_change(4);
	}
}
attack = function(version){
	switch(version) {
		case 0:
			var angle;
			var dir_x = target.x - x+(facing_x*24);
			var dir_y = target.y - y+(sprite_width/2);
			angle = point_direction(x+(facing_x*24), y+(sprite_width/2), target.x, target.y);
			
			instance_create_bullet(x+(facing_x*24), y+sprite_width/2, angle, 2, 2, target, 1, 4);
			instance_create_bullet(x+(facing_x*24), y+sprite_width/2, angle+10, 2, 1, target, 1, 4);
			instance_create_bullet(x+(facing_x*24), y+sprite_width/2, angle-10, 2, 1, target, 1, 4);
			
		break;
		
		case 1:
			instance_create_layer(x, y+sprite_width/2, layer, obj_disc);
		break;
		
		case 2:
			instance_create_layer(x, y+sprite_width/2, layer, obj_zombie);
		break;
	}
}

#region //states
function state_move(){
	velocity_x = lerp(velocity_x, 0, drag);
	
	var dir = target.x - x;
	
	if (abs(dir) < 32) {
		state_machine.state_change(1);
	}
	else {
		velocity_x = move_speed * sign(dir);
	}
	
	i_frames_counter = (i_frames_counter > 0 )? i_frames_counter-1 : 0;
	
	velocity_y += grav;
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);	
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
}
function state_attack(){
	if (state_machine.state_timer == 120) {
		attack(choose(0, 1, 2));
		state_machine.state_change(0);
	}
	
	velocity_x = lerp(velocity_x, 0, drag);
	
	i_frames_counter = (i_frames_counter > 0 )? i_frames_counter-1 : 0;
	
	velocity_y += grav;
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);	
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
}
function state_die(){
	obj_camera.do_screenshake(300, 4);
	
	i_frames_counter = -2;
	
	velocity_y += grav;
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);	
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
}
#endregion

state_machine = new StateMachine([state_move, state_attack, state_die], id);
state_machine.state_change(0);
