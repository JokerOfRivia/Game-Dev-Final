event_inherited();
time = 300;

function init(x, y, angle, velocity, size, target, damage, knockback){
	obj_sound.play_sfx(sfx_wow);
	self.x = x;
	self.y = y;
	self.angle = angle;
	self.velocity = velocity;
	
	self.size = size;
	
	image_xscale = size;
	image_yscale = size;
	
	self.target = target;
	self.damage = damage;
	self.knockback = knockback;
}

function step(){
	image_angle = angle;
	var velocity_x = velocity * dcos(angle);
	var velocity_y = -1*velocity * dsin(angle);
	
	var hit = noone;
	hit = instance_place(x+velocity_x, y+velocity_y, target);
	if (hit == noone) hit = instance_place(x, y, target);
	
	if (hit!=noone) {
		hit.take_knockback(knockback*dcos(angle), -1* knockback*dsin(angle));
		hit.take_damage(damage);
		instance_destroy();
	}
	else if (time < 1) instance_destroy();
	
	move_x(velocity_x, instance_destroy);
	move_y(velocity_y, instance_destroy);
	
	time--;
}

function deflect(new_target) {
	if (new_target!=target) {
		angle-=(180 + irandom_range(-1, 1));
		target = new_target;
	}
	time = 300;
}
