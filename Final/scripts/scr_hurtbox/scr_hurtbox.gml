function instance_create_hurtbox(local_x, local_y, width, height, time, parent, target, damage){
	var hurtbox = instance_create_layer(0, 0, layer, obj_hurtbox);
	hurtbox.init(local_x, local_y, width, height, time, parent, target, damage);
}