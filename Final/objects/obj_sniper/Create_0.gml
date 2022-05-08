event_inherited();

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
move_speed = 0.8;
drag = 0.4;
grav = 1.5;

//gun
bullet_speed = 10;
#endregion

#region //ai
	target = noone;
	target_range = 200;
	maintain_distance = 64;
#endregion

take_knockback = function(knockback_x, knockback_y){
	if (i_frames_counter < 1) {
		velocity_x+=knockback_x;
		velocity_y+=knockback_y;
	}
}
attack = function(angle){
	var bullet = instance_create_layer(x, y, layer, obj_bullet);
}
get_target = function(){
	var hit = collision_line_first(x, y, target.x, target.y, obj_actorsolid, false, true);
	if (hit==obj_player) {
		target = hit;
	}
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
	}
}

