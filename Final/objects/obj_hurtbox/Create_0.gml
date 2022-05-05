time = 0;
parent = noone;
target = noone;
damage = 0;
local_x = 0;
local_y = 0;
knockback_x = 0;
knockback_y = 0;

if (debug_mode){
	visible = true;
}

function init(local_x, local_y, width, height, time, parent, target, damage, knockback_x, knockback_y){
	self.x = parent!=noone ? parent.x + local_x : local_x;
	self.y = parent!=noone ? parent.y + local_y : local_y;
	
	self.local_x = local_x;
	self.local_y = local_y;
	
	image_xscale = width;
	image_yscale = height;
	
	self.time = time;
	self.object = parent;
	self.target = target;
	
	self.knockback_x = knockback_x;
	self.knockback_y = knockback_y;
}

function step(){
	if ((!instance_exists(object) and object!=noone) or time < 1){
		instance_destroy();
		exit;
	}
	else {
		if (object!=noone) {
			x = object.x + local_x;
			y = object.y + local_y;
		}
		
		var hit_list = ds_list_create();
		var n = instance_place_list(x, y, target, hit_list, false);
		if (n > 0){
			for (var i = 0; i < n; ++i) {
			    var hit_actor = hit_list[|i ];
				hit_actor.take_damage(damage);
				if (variable_instance_exists(hit_actor, "take_knockback")) {
					hit_actor.take_knockback(knockback_x, knockback_y);
				}
			}
		}
		ds_list_destroy(hit_list);
		time--;
	}
	
}
