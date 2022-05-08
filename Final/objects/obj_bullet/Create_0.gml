event_inherited();
time = 300;
function init(x, y, angle, velocity, size, target, damage, knockback){
	self.x = x;
	self.y = y;
	self.angle = angle;
	self.velocity = velocity;
	
	image_xscale = size;
	image_yscale = size;
	
	self.target = target;
	self.damage = damage;
	self.knockback = knockback;
}

function step(){
	image_angle = angle;
	var velocity_x = velocity*dcos(angle);
	var velocity_y = velocity*dsin(angle);
	
	var hit = collision_line_first(x, y, x + velocity_x, y + velocity_y, obj_actorsolid, false, true);
	
	if (hit!=noone) {
		if (hit==target) {
			if (variable_instance_exists(hit, "take_knockback")) hit_actor.take_knockback(knockback*dcos(angle), knockback*dsin(angle));
			if (variable_instance_exists(hit, "take_damage")) hit_actor.take_damage(damage);
		}
		instance_destroy();
	}
	else if (time < 1) instance_destroy();
	
	move_x(velocity_x, instance_destroy);
	move_y(velocity_y, instance_destroy);
	time--;
}

function deflect(new_target){
	angle-=(180 + irandom_range(-1, 1));
	target = new_target;
	time = 300;
}
