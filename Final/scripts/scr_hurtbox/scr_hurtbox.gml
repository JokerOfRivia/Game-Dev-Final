function instance_create_hurtbox(local_x, local_y, width, height, time, parent, target, damage, knockback_x, knockback_y){
	var hurtbox = instance_create_layer(0, 0, layer, obj_hurtbox);
	hurtbox.init(local_x, local_y, width, height, time, parent, target, damage, knockback_x, knockback_y);
}