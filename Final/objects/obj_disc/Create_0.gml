event_inherited();

#region //gameplay values
hp_max = 1;
hp = hp_max;

i_frames = 15;
i_frames_counter = -1;
#endregion

#region //physics values
velocity_x = 0;
velocity_y = 0;
velocity_max = 20;

//govern horizontal movement and gravity
move_speed = 1.5;
drag = 0.4;
grav = 1.5;
#endregion

function cancel_velocity_x(){
	velocity_x *= -1;
}
function cancel_velocity_y(){
	velocity_y = 0;
}
default_squish_action = instance_destroy;

#region //ai
	target = obj_player;
#endregion

hurtbox = instance_create_hurtbox(x-2, y+8, sprite_width+2, sprite_height-8, -100, id, target, 0, -6);

take_damage = function(amount){
	if (i_frames_counter < 1){
		obj_camera.do_screenshake(6, amount);
		obj_sound.play_sfx(sfx_hit);
		hp -= amount;
	}
	if (hp < 1) state_machine.state_change(1);
}

take_knockback = function(knockback_x, knockback_y){
	if (i_frames_counter < 1) {
		velocity_x+=knockback_x/3;
		velocity_y+=knockback_y/3;
	}
}
function edge_check(x_check, y_check){
	if !collide_check(x_check, y_check+8) return true;
	else return false;
}


#region //states
//0
function state_move(){
	var edge = edge_check(x + velocity_x, y);
	
	if (edge or collide_check(x+velocity_x, y)) move_speed *= -1;
	
	velocity_x += move_speed;
	
	velocity_x = lerp(velocity_x, 0, drag);	
	
	
	//count down i frames from hit
	i_frames_counter = (i_frames_counter > 0 )? i_frames_counter-1 : 0;
	
	velocity_y += grav;
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);	
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
}

//2
function state_die(){
	var drop = instance_create_layer(x, y, layer, obj_health_pickup);
	drop.velocity_x = velocity_x;
	drop.velocity_y = velocity_y;
	
	instance_destroy();
	
	velocity_x = clamp(velocity_x, -velocity_max, velocity_max);
	velocity_y = clamp(velocity_y, -velocity_max, velocity_max);
	
	move_x(velocity_x, cancel_velocity_x);
	move_y(velocity_y, cancel_velocity_y);
}

#endregion

state_machine = new StateMachine([state_move, state_die], id);
state_machine.state_change(0);
