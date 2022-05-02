time = 0;
parent = noone;
target = noone;
damage = 0;
local_x = 0;
local_y = 0;

if (debug_mode){
	visible = true;
}

function init(local_x, local_y, width, height, time, parent, target, damage){
	self.x = parent!=noone ? parent.x + local_x : local_x;
	self.y = parent!=noone ? parent.y + local_y : local_y;
	
	self.local_x = local_x;
	self.local_y = local_y;
	
	image_xscale = width/sprite_width;
	image_yscale = height/sprite_height;
	
	self.time = time;
	self.object = parent;
	self.target = target;
}

function step(){
	if (time < 1) instance_destroy();
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
			}
		}
		ds_list_destroy(hit_list);
		time--;
	}
	
}
