time = 1;
radius = 1;
damage = 1;
knockback = 5;

if (debug_mode){
	visible = true;
}

function init(x, y, radius, time, target, damage, knockback){
	self.x = x;
	self.y = y;
	
	image_xscale = radius;
	image_yscale = radius;
	
	self.time = time;
	self.target = target;
	self.damage = damage;
	self.knockback = knockback;
}

function step(){
	if (time < 1){
		instance_destroy();
		exit;
	}
	else {	
		var hit_list = ds_list_create();
		var n = instance_place_list(x, y, target, hit_list, false);
		if (n > 0) {
			for (var i = 0; i < n; ++i) {
			    var hit_actor = hit_list[|i ];
				if (variable_instance_exists(hit_actor, "take_knockback")) {
					var ref_x = hit_actor.x;
					var ref_y = hit_actor.y;
					
					var vec_x = ref_x - x;
					var vec_y = ref_y - y;
					
					var mag = magnitude(vec_x, vec_y);
					
					var kb_x = vec_x/mag;
					var kb_y = vec_y/mag;
					
					hit_actor.take_knockback(kb_x, kb_y);
				}
				hit_actor.take_damage(damage);
			}
		}
		ds_list_destroy(hit_list);
		time--;
	}
	
}
